module TLC_tb;

wire [1:0] East_r, West_r, North_r, South_r;
reg [3:0] emergency;
reg clk, rst;

// Instantiate DUT
TLC DUT (
    .clk(clk),
    .rst(rst),
    .emergency(emergency),
    .East_r(East_r),
    .West_r(West_r),
    .North_r(North_r),
    .South_r(South_r)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1'b1;
    repeat(5) @(negedge clk);
    rst = 1'b0;
end


initial begin
    emergency = 4'b0000;  
    #200 emergency = 4'b0001; 
    #200 emergency = 4'b0000;
    #200 emergency = 4'b0100; 
    #200 emergency = 4'b0000;
    #100 $finish;
end


initial begin
    $dumpfile("dump.vcd");      
    $dumpvars(0, TLC_tb);
    $monitor("Time=%0t | Emergency=%b | N=%b E=%b S=%b W=%b",
              $time, emergency, North_r, East_r, South_r, West_r);
end

endmodule
