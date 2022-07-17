`timescale 1ns/1ns
module Washingachine_tb  ();

    reg clk_tb;
    reg rst_n_tb;
    reg [1:0] clk_freq_tb;
    reg coin_in_tb;
    reg double_wash_tb;
    reg timer_pause_tb;
    wire wash_done_tb;
    wire [2:0] CurrentState_tb;

    parameter Clk_Frq_1 = 1000;
    parameter Clk_Frq_2 = Clk_Frq_1/2;
    parameter Clk_Frq_3 = Clk_Frq_1/4;
    parameter Clk_Frq_4 = Clk_Frq_1/8;
    reg [9:0] Selected_Clock;
    parameter  Min2_frq1=32'd118 ,Min2_frq2=32'd238,Min2_frq3=32'd478,Min2_frq4=32'd958,
                Min5_frq1=32'd298 ,Min5_frq2=32'd598,Min5_frq3=32'd1198,Min5_frq4=32'd2398,
                Min1_frq1=32'd58  ,Min1_frq2=32'd118,Min1_frq3=32'd238,Min1_frq4=32'd478;







    initial begin

        clk_freq_tb=2'b01;

        case (clk_freq_tb)
            2'b00: begin
               // #Clk_Frq_1 clk_tb = ~ clk_tb;
               Selected_Clock=Clk_Frq_1;
            end 
            2'b01: begin
                //#Clk_Frq_2 clk_tb = ~ clk_tb;
                Selected_Clock=Clk_Frq_2;
            end
            2'b10:begin
                //#Clk_Frq_3 clk_tb = ~ clk_tb;
                Selected_Clock=Clk_Frq_3;
            end 
            2'b11: begin
                //#Clk_Frq_4 clk_tb = ~ clk_tb;
                Selected_Clock=Clk_Frq_4;
            end
        endcase
    end
    
    always #(Selected_Clock/2) clk_tb= ~ clk_tb;




    initial begin
        $dumpfile("Washingachine.vcd");
        $dumpvars ;
        clk_tb=1'b1;
        rst_n_tb=1'b0;
        coin_in_tb=1'b1;
        double_wash_tb=1'b0;
        timer_pause_tb=1'b0;
        
        $monitor("Curresnt State at time=%0t=0x%3b ",$time,CurrentState_tb);
        repeat(2)#Selected_Clock;

        //*testing The hierarchy of the rest signal.
        $display("Test Case #1 RST");
        if (wash_done_tb ) begin
            $display("Passed");
        end else begin
            $display("Failed");
        end

        //*No coin is deposited 
        coin_in_tb=1'b0;
        #Selected_Clock;
        rst_n_tb=1'b1;
        repeat(2)#Selected_Clock;
        $display("Test Case #2 No coin inserted");
        if (wash_done_tb) begin
            $display("Passed DONE IS ASSERTED");
        end else begin
            $display("Failed DONE IS NOT ASSERTED");
        end

        //*Coin is deposited the wash done should go low and the machine statrts 
        coin_in_tb=1'b1;
        $display("time=%0t",$time);
        repeat(2)#Selected_Clock;
        $display("Test Case #3 coin inserted");
        if (!wash_done_tb) begin
            $display("Passed");
        end else begin
            $display("Failed");
        end
        coin_in_tb=1'b0;

        //*•	Coin is deposited observing the corresponding time taken by every state.
        wait(wash_done_tb)
        $display("Test Case #4 Washing is done");
        repeat(5)#Selected_Clock;

        //*•	Double wash option is asserted 
        coin_in_tb=1'b1;
        double_wash_tb=1'b1;
        repeat(5)#Selected_Clock;
        coin_in_tb=1'b0;
        $display("Test Case #5 Double Wash");
        wait(wash_done_tb)

     
        coin_in_tb=1'b1;
        double_wash_tb=1'b0;
        repeat(5)#Selected_Clock;
        $display("Test Case #5 Stop The Timer ");

        //*Timer pause is asserted at the rinsing state the counter should not pause
        wait(CurrentState_tb==3'b111) 
        repeat(10)#Selected_Clock;
        timer_pause_tb=1'b1;
        repeat(30)#Selected_Clock;
        timer_pause_tb=1'b0;
        repeat(10)#Selected_Clock;

        //*Timer pause is asserted at the spinning state the counter should  pause
        //*untill the timer pause is deasserted 
        wait(CurrentState_tb==3'b110) 
        repeat(10)#Selected_Clock;
        timer_pause_tb=1'b1;
        repeat(30)#Selected_Clock;
        timer_pause_tb=1'b0;
        wait(wash_done_tb)
        repeat(10)#Selected_Clock;
       
        


        $stop;

    end

WashingachineTop #(
    .Min2_frq1 (Min2_frq1 ),
    .Min2_frq2 (Min2_frq2 ),
    .Min2_frq3 (Min2_frq3 ),
    .Min2_frq4 (Min2_frq4 ),
    .Min5_frq1 (Min5_frq1 ),
    .Min5_frq2 (Min5_frq2 ),
    .Min5_frq3 (Min5_frq3 ),
    .Min5_frq4 (Min5_frq4 ),
    .Min1_frq1 (Min1_frq1 ),
    .Min1_frq2 (Min1_frq2 ),
    .Min1_frq3 (Min1_frq3 ),
    .Min1_frq4 (Min1_frq4 )
)
u_WashingachineTop(
    .clk_Top         (clk_tb         ),
    .rst_n_Top       (rst_n_tb       ),
    .clk_freq_Top    (clk_freq_tb    ),
    .coin_in_Top     (coin_in_tb     ),
    .double_wash_Top (double_wash_tb ),
    .timer_pause_Top (timer_pause_tb ),
    .CurrentState_Top(CurrentState_tb),
    .wash_done_Top   (wash_done_tb   )
);



    

    
endmodule