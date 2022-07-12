module WashingMachineController #(
    parameter FillingWaterTimeInSec=120,WashingTimeInSec=300,
              RinsingTimeInSec=120,SpinningTimeInSec=60,
              clk_freq_1=1*10^6,clk_freq_2=2*clk_freq_1,
              clk_freq_3=4*clk_freq_1,clk_freq_4=8*clk_freq_1


) (
    input wire rst_n,
    input wire clk,
    input wire [1:0] clk_freq,
    input wire coin_in,
    input wire double_wash,
    input wire timer_pause,
    input wire StateFinish,
    output reg [2:0] CurrentState,
    output reg Counter_RST_From_FSM,
    output reg wash_done

);
reg [2:0] NextState;

localparam Idle =3'b000,
           FillingWater=3'b001,
           Washing=3'b011,
           Rinsing=3'b111,
           Spinning=3'b110;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        CurrentState<=Idle;
    end else begin
        CurrentState<=NextState;
    end
end

always @(*) begin
    wash_done=1'b0;
    case (CurrentState)
        Idle: begin
            if (!coin_in) begin
                NextState<=Idle;
                Counter_RST_From_FSM=1'b1;
            end else begin
                NextState<=FillingWater;
                Counter_RST_From_FSM=1'b0;
            end
            
        end 

        FillingWater: begin
            if (!StateFinish) begin
                NextState<=FillingWater;
                Counter_RST_From_FSM=1'b1;
            end else begin
                NextState<=Washing;
                Counter_RST_From_FSM=1'b0;
                
            end
        end

        Washing:begin
            if (!StateFinish) begin
                NextState<=Washing;
                Counter_RST_From_FSM=1'b1;
            end else begin
                NextState<=Rinsing;
                Counter_RST_From_FSM=1'b0;
            end
        end

        Rinsing:begin
            if (!StateFinish) begin
                NextState<=Rinsing;
                Counter_RST_From_FSM=1'b1;
            end else begin
                NextState<=Spinning;
                Counter_RST_From_FSM=1'b0;
                
            end
        end

        Spinning:begin
            if (!StateFinish) begin
                NextState<=Spinning;
                Counter_RST_From_FSM=1'b1;
            end else begin
                NextState<=Idle;
                Counter_RST_From_FSM=1'b0;
                wash_done=1'b1;
                
            end

        end


        default:begin
            NextState<=Idle;
        end
    endcase
    
end
    
endmodule