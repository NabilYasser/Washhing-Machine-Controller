module ROM (
    input wire [1:0] clk_freq,
    input wire [2:0] StateFromController,
    output reg [31:0] CountsNum
);
    
    always @(*) begin
        case ({StateFromController,clk_freq})
            5'b00100,5'b11100: begin
                CountsNum=32'd120000000;
            end
            5'b00101,5'b11101: begin
                CountsNum=32'd240000000;
            end
            5'b00110,5'b11110: begin
                CountsNum=32'd480000000;
            end
            5'b00111,5'b11111: begin
                CountsNum=32'd960000000;
            end

            5'b01100: begin
                CountsNum=32'd300000000;
            end
            5'b01101: begin
                CountsNum=32'd600000000;
            end
            5'b01110: begin
                CountsNum=32'd1200000000;
            end
            5'b01111: begin
                CountsNum=32'd2400000000;
            end

            5'b11000: begin
                CountsNum=32'd60000000;
            end
            5'b11001: begin
                CountsNum=32'd120000000;
            end
            5'b11010: begin
                CountsNum=32'd240000000;
            end
            5'b11011: begin
                CountsNum=32'd480000000;
            end
            
            default:begin
                CountsNum=32'b0;
            end 
        endcase
        
    end
endmodule