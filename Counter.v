module Counter #(
    parameter FillingWaterTimeInSec=9'b001111000,WashingTimeInSec=9'b100101100,
              RinsingTimeInSec=9'b001111000,SpinningTimeInSec=9'b000111100,
              clk_freq_1=4'b0001,clk_freq_2=2*clk_freq_1,
              clk_freq_3=4*clk_freq_1,clk_freq_4=8*clk_freq_1
) (
    input wire Counter_RST,
    input wire clk,
    input wire [31:0] Counts,
    output reg StateFinish 

);

reg [31:0] Counter;

always @(posedge clk or negedge Counter_RST) begin
    if (!Counter_RST) begin
       // Counter<='b0;
        Counter<='b00000111001001110000111000000000-'b10;
    end else begin
        Counter<=Counter+1'b1;
    end
    
end

always @(posedge clk ) begin
    if (Counter==Counts) begin
        StateFinish<=1'b1;
    end else begin
         StateFinish<=1'b0;
    end
    
end
endmodule