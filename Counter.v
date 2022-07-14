module Counter #(
    parameter FillingWaterTimeInSec=9'b001111000,WashingTimeInSec=9'b100101100,
              RinsingTimeInSec=9'b001111000,SpinningTimeInSec=9'b000111100,
              clk_freq_1=4'b0001,clk_freq_2=2*clk_freq_1,
              clk_freq_3=4*clk_freq_1,clk_freq_4=8*clk_freq_1
) (
    //*Declaring the input and output ports of the module.
    input wire Counter_RST,
    input wire clk,
    input wire [31:0] Counts,
    input wire CounterStop,
    output reg StateFinish 

);

reg [31:0] Counter;

//*This is a sequential logic block. It is triggered by the rising edge of the clock signal or the falling edge of the reset signal. 
//*If the reset signal is low, the counter is set to zero. 
//*If the counter stop signal is low, the counter is incremented by one. Otherwise, the counter is not changed.
always @(posedge clk or negedge Counter_RST) begin
    if (!Counter_RST) begin
        Counter<='b0;
    end else if(!CounterStop) begin
        Counter<=Counter+1'b1;
    end else begin
        Counter<=Counter;
    end
    
end

//*This is a sequential logic block. It is triggered by the rising edge of the clock signal.
//*If the counter reaches the input counts, the StateFinish is asserted . Otherwise, the StateFinish remains 0

always @(posedge clk) begin
    if (Counter==Counts) begin
        StateFinish<=1'b1;
    end else begin
         StateFinish<=1'b0;
    end
    
end
endmodule