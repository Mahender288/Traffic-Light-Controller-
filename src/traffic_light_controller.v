
module TLC(
    input clk,
    input rst,
    input [3:0] emergency,
    output reg [1:0] East_r,
    output reg [1:0] West_r,
    output reg [1:0] North_r,
    output reg [1:0] South_r
);

// State encoding
typedef enum reg [2:0] {
    North_green   = 3'b000,
    North_yellow  = 3'b001,
    East_green    = 3'b010,
    East_yellow   = 3'b011,
    South_green   = 3'b100,
    South_yellow  = 3'b101,
    West_green    = 3'b110,
    West_yellow   = 3'b111
} state_t;

state_t state, next_state;


parameter RED       = 2'd0;
parameter YELLOW    = 2'd1;
parameter GREEN     = 2'd2;

always @(posedge clk or posedge rst) begin
    if (rst)
        state <= North_green;
    else
        state <= next_state;
end

always @(*) begin
    // Default all red
    North_r = RED;
    East_r  = RED;
    South_r = RED;
    West_r  = RED;

    case(state)
        North_green:  North_r = GREEN;
        North_yellow: North_r = YELLOW;

        East_green:   East_r = GREEN;
        East_yellow:  East_r = YELLOW;

        South_green:  South_r = GREEN;
        South_yellow: South_r = YELLOW;

        West_green:   West_r = GREEN;
        West_yellow:  West_r = YELLOW;
    endcase
end

// Next state logic
always @(*) begin
    case(state)
        North_green:  
            if (emergency == 4'b1000) next_state = North_green; 
      else next_state = North_yellow;

        North_yellow: next_state = East_green;

        East_green:  
            if (emergency == 4'b0100) next_state = East_green; 
            else next_state = East_yellow;

        East_yellow: next_state = South_green;

        South_green: 
            if (emergency == 4'b0010) next_state = South_green; 
            else next_state = South_yellow;

        South_yellow: next_state = West_green;

        West_green:  
            if (emergency == 4'b0001) next_state = West_green; 
            else next_state = West_yellow;

        West_yellow: next_state = North_green;

        default: next_state = North_green;
    endcase
end

endmodule
