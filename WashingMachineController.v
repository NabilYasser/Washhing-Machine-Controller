module WashingMachineController #(
    parameter FillingWaterTimeInSec=120,WashingTimeInSec=300,
              RinsingTimeInSec=120,SpinningTimeInSec=60,
              clk_freq_1=1*10^6,clk_freq_2=2*clk_freq_1,
              clk_freq_3=4*clk_freq_1,clk_freq_4=8*clk_freq_1


) (
    //*Declaring the input and output signals of the module.
    input wire rst_n,
    input wire clk,
    input wire [1:0] clk_freq,
    input wire coin_in,
    input wire double_wash,
    input wire timer_pause,
    input wire StateFinish,
    output reg [2:0] CurrentState,
    output reg Counter_RST_From_FSM,
    output reg CounterStop,
    output reg wash_done

);

reg [2:0] NextState;
reg Tocin,Enable;
//*This is the declaration of the states of the FSM.
localparam Idle =3'b000,
           FillingWater=3'b001,
           Washing=3'b011,
           Rinsing=3'b111,
           Spinning=3'b110;


 //********************* State Memory **********************//
//*This is a sequential logic block. It is used to update the value of the output signal (CurrentState) at the positive edge of the clock signal. 
//*The output signal is updated with the value of the signal (NextState) at the positive edge of the clock signal.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        CurrentState<=Idle;
    end else begin
        CurrentState<=NextState;
    end
end

always @(*) begin
    wash_done=1'b0;
    CounterStop=1'b0;
    Enable=1'b0;
    case (CurrentState)
        //*The first state of the FSM. It is the state where the washing machine is idle.
        //* It is waiting for the coin to be inserted. If the coin is inserted, the next state is FillingWater. 
        //*If the coin is not inserted, the next state is Idle.
        Idle: begin
            wash_done=1'b1;
            if (!coin_in) begin
                NextState=Idle;
                Counter_RST_From_FSM=1'b0;
            end else begin
                NextState=FillingWater;
                Counter_RST_From_FSM=1'b0;
            end
            
        end 

       //*This is the state where the washing machine is filling water. 
       //* If the state is not finished, the next state is FillingWater. If the state is finished, the next state is Washing,and the counter is reset
        FillingWater: begin
            if (!StateFinish) begin
                NextState=FillingWater;
                Counter_RST_From_FSM=1'b1;
            end else begin
                NextState=Washing;
                Counter_RST_From_FSM=1'b0;
                
            end
        end

        //*This is the state where the washing machine is washing. 
        //*If the state is not finished, the next state is Washing. If the state is finished, the next state is Rinsing,and the counter is reset
        Washing:begin
            if (!StateFinish) begin
                NextState=Washing;
                Counter_RST_From_FSM=1'b1;
            end else begin
                NextState=Rinsing;
                Counter_RST_From_FSM=1'b0;
            end
        end

        //*This is the state where the washing machine is rinsing. 
        //*If the state is not finished, the next state is Rinsing. If the state is finished, the next state is Spinning,and the counter is reset
        //* If the state is finished and the double_wash is asserted, the next state is Washing,and the counter is reset
        //*Enable is asserted macking the tocin latch has a 0 ,preventing the machine from looping and only double wash.
        Rinsing:begin
            if (!StateFinish) begin
                NextState=Rinsing;
                Counter_RST_From_FSM=1'b1;
            end else if (!(double_wash & Tocin)) begin
                NextState=Spinning;
                Counter_RST_From_FSM=1'b0;
            end else begin
                NextState=Washing;
                Counter_RST_From_FSM=1'b0;
                Enable=1'b1;
                
            end
        end

        //*Checking if the timer_pause is asserted. If it is asserted, the next state is Spinning and the counter Stop is asserted.
        //* If it is not asserted,  and the counter finshed the next state is Idle and the counter is reset.
        Spinning:begin
            if (!timer_pause) begin
                if (!StateFinish) begin
                NextState=Spinning;
                Counter_RST_From_FSM=1'b1;
                end else begin
                NextState=Idle;
                Counter_RST_From_FSM=1'b0;
                end
            end else begin
                NextState=Spinning;
                Counter_RST_From_FSM=1'b1;
                CounterStop=1'b1;
            end
        end

        default:begin
            NextState=Idle;
            Counter_RST_From_FSM=1'b0;
        end
    endcase
 
end

//*A latch that is used to prevent the machine from looping and only double wash.
    always @( posedge clk or negedge rst_n ) begin
        if (!rst_n) begin
            Tocin<=1'b1;
        end else if(Enable) begin
            Tocin<=1'b0;
        end
        
    end
    
endmodule