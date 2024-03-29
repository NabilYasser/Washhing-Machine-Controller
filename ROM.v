module ROM #(parameter  Min2_frq1=32'd118000000 ,Min2_frq2=32'd238000000,Min2_frq3=32'd478000000,Min2_frq4=32'd958000000,
                        Min5_frq1=32'd298000000 ,Min5_frq2=32'd598000000,Min5_frq3=32'd1198000000,Min5_frq4=32'd2398000000,
                        Min1_frq1=32'd58000000  ,Min1_frq2=32'd118000000,Min1_frq3=32'd238000000,Min1_frq4=32'd478000000
)
(
    input wire [1:0] clk_freq,
    input wire [2:0] StateFromController,
    output reg [31:0] CountsNum
);
//*This is a ROM stores the number of counts to meet the required time for each state corsponding to each clock freq.
//* You can notice that there is a commented value in every case , this is a scaled value of the orginal value used to speed up testing 
//* as for the orginal value like 2 min the test bench will take hours to varifay the design , 
//*but with the scaled value it will take sconds and giving the same result at least at this early stage of testing 
    
    always @(*) begin
        case ({StateFromController,clk_freq})
            5'b00100,5'b11100: begin
                CountsNum=Min2_frq1;
            end
            5'b00101,5'b11101: begin
                CountsNum=Min2_frq2;
            end
            5'b00110,5'b11110: begin
                CountsNum=Min2_frq3;
            end
            5'b00111,5'b11111: begin
               CountsNum=Min2_frq4;
            end

            5'b01100: begin
                //CountsNum=32'd298000000;
               CountsNum=Min5_frq1;
            end
            5'b01101: begin
                //CountsNum=32'd598000000;
                CountsNum=Min5_frq2;
            end
            5'b01110: begin
                //CountsNum=32'd1198000000;
                CountsNum=Min5_frq3;
            end
            5'b01111: begin
                //CountsNum=32'd2398000000;
                CountsNum=Min5_frq4;
            end

            5'b11000: begin
                //CountsNum=32'd58000000;
                CountsNum=Min1_frq1;
            end
            5'b11001: begin
                //CountsNum=32'd118000000;
                CountsNum=Min1_frq2;
            end
            5'b11010: begin
                //CountsNum=32'd238000000;
                CountsNum=Min1_frq3;
            end
            5'b11011: begin
                //CountsNum=32'd478000000;
                CountsNum=Min1_frq4;
            end
            
            default:begin
                CountsNum=32'b01;
            end 
        endcase
        
    end
endmodule