//*This module is responsbole for interconnecting the diffrent units
module WashingachineTop (
    
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
    ROM u_ROM(
    	.clk_freq            (clk_freq_Top            ),
        .StateFromController (CurrentState_Top ),
        .CountsNum           (Counts_Top           )
    );
    
    
    
endmodule