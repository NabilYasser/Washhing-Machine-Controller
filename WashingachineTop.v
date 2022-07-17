//*This module is responsbole for interconnecting the diffrent units
module WashingachineTop #(parameter  Min2_frq1=32'd118000000 ,Min2_frq2=32'd238000000,Min2_frq3=32'd478000000,Min2_frq4=32'd958000000,
                        Min5_frq1=32'd298000000 ,Min5_frq2=32'd598000000,Min5_frq3=32'd1198000000,Min5_frq4=32'd2398000000,
                        Min1_frq1=32'd58000000  ,Min1_frq2=32'd118000000,Min1_frq3=32'd238000000,Min1_frq4=32'd478000000
) (
    
    input wire clk_Top,
    input wire rst_n_Top,
    input wire [1:0] clk_freq_Top,
    input wire coin_in_Top,
    input wire double_wash_Top,
    input wire timer_pause_Top,

    output wire [2:0] CurrentState_Top,
    output wire wash_done_Top

);
wire Counter_RST_Top,StateFinish_Top,CounterStop_Top;
wire [31:0] Counts_Top;

///********wire [2:0] CurrentState_Top;
wire Counter_RST_From_FSM_Top;

assign Counter_RST_Top=(rst_n_Top & Counter_RST_From_FSM_Top);

    Counter u_Counter(
    	.Counter_RST (Counter_RST_Top ),
        .clk         (clk_Top         ),
        .Counts      (Counts_Top      ),
        .CounterStop (CounterStop_Top ),
        .StateFinish (StateFinish_Top )
    );


    //Instantiating the module WashingMachineController.
    WashingMachineController  u_WashingMachineController(
    	.rst_n                (rst_n_Top                ),
        .clk                  (clk_Top                  ),
        .clk_freq             (clk_freq_Top             ),
        .coin_in              (coin_in_Top              ),
        .double_wash          (double_wash_Top          ),
        .timer_pause          (timer_pause_Top          ),
        .StateFinish          (StateFinish_Top          ),
        .CurrentState         (CurrentState_Top         ),
        .Counter_RST_From_FSM (Counter_RST_From_FSM_Top ),
        .CounterStop          (CounterStop_Top          ),
        .wash_done            (wash_done_Top            )
    );

    //Instantiating the module ROM.
    ROM #(
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
    u_ROM(
    	.clk_freq            (clk_freq_Top            ),
        .StateFromController (CurrentState_Top ),
        .CountsNum           (Counts_Top           )
    );
    


    
    
    
endmodule