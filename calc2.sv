`define CLK_PERIOD 10

interface calc_ifc(input bit clk);
  
  logic [0:31] out_data1, out_data2, out_data3, out_data4;
  logic [0:1] out_resp1, out_resp2, out_resp3, out_resp4;
  logic [0:1] out_tag1, out_tag2, out_tag3, out_tag4;

  logic scan_out;   //took error_found out and added out_tag
  
  logic [0:3] req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
  logic [0:31] req1_data_in, req2_data_in, req3_data_in, req4_data_in;
  logic [0:1] req1_tag_in, req2_tag_in, req3_tag_in, req4_tag_in;

  logic [1:7] reset;
  logic scan_in;

  // Now, we're using a clocking block in our interface.
  clocking cb @(posedge clk);
    input 
    out_data1, out_data2, out_data3, out_data4,
    out_resp1, out_resp2, out_resp3, out_resp4, 
    out_tag1, out_tag2, out_tag3, out_tag4,
    scan_out; 

    output
    req1_cmd_in, req1_data_in, req1_tag_in,
    req2_cmd_in, req2_data_in, req2_tag_in,
    req3_cmd_in, req3_data_in, req3_tag_in,
    req4_cmd_in, req4_data_in, req4_tag_in,
    scan_in;
  endclocking

  modport TEST_PROGRAM(clocking cb, output reset); 
    
endinterface

class RequestRand;
  rand bit [0:3] cmd;
  rand bit [0:31] operand1, operand2;

  constraint c {
    cmd inside{1,2,3,5};
  }
endclass


program automatic test(calc_ifc.TEST_PROGRAM calc_ifc1);
  RequestRand request_queue[$];
  RequestRand req;
  logic [0:31] expected_output;
  logic valid_cmd;
  int number_of_tests = 10;

  initial begin 
    for(int i = 0; i < number_of_tests; i++)begin
      req = new();
      if(!req.randomize()) $finish;
      request_queue.push_back(req);
    end
    //resetting the calc
    calc_ifc1.reset <= 7'b1111111;
    repeat (7) @calc_ifc1.cb;
    calc_ifc1.reset <= 0;
    //now test untill every operation in the queue has been completed
    while(request_queue.size() != 0) begin 
      RequestRand req;
      req = request_queue.pop_front();

      @calc_ifc1.cb;
      calc_ifc1.cb.req1_cmd_in <= req.cmd;
      calc_ifc1.cb.req1_data_in <= req.operand1;
      @calc_ifc1.cb;
      calc_ifc1.cb.req1_cmd_in <= 0;
      calc_ifc1.cb.req1_data_in <= req.operand2;

      @(calc_ifc1.cb.out_resp1);

      if(req.cmd == 1) begin
        valid_cmd = 1;
        expected_output = req.operand1 + req.operand2;
      end
      if(req.cmd == 1) begin
        valid_cmd = 1;
        expected_output = req.operand1 - req.operand2;
      end
      if(req.cmd == 3) valid_cmd = 0;

      if(req.cmd == 1) begin
        valid_cmd = 1;
        expected_output = req.operand1 << req.operand2;
      end

      if(valid_cmd == 0)
        assert(calc_ifc1.cb.out_resp1 == 2)
      else begin
        $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data1, req.operand1, req.operand2, req.cmd);
        continue;
      end
      
      assert(calc_ifc1.cb.out_data1 == expected_output) 
        $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
          req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
      else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
        calc_ifc1.cb.out_data1, expected_output, req.operand1, req.operand2, req.cmd);
    end
  

  end
endprogram

module testbench();
  //questions about the clock
  bit clk;

  initial clk = 0;
  always #(`CLK_PERIOD/2) clk = !clk;
  //do i need to change the clock any sort of way
  calc_ifc calc_ifc1(clk);

  calc2_top calc( //i pulled all parameters out from calc2_top
    calc_ifc1.out_data1, calc_ifc1.out_data2, calc_ifc1.out_data3, calc_ifc1.out_data4, 
    calc_ifc1.out_resp1, calc_ifc1.out_resp2, calc_ifc1.out_resp3, calc_ifc1.out_resp4, 
    calc_ifc1.out_tag1, calc_ifc1.out_tag2, calc_ifc1.out_tag3, calc_ifc1.out_tag4,
    calc_ifc1.scan_out,
    clk, clk, clk //calc_ifc1.a_clk, calc_ifc1.b_clk, calc_ifc1.c_clk,
    calc_ifc1.req1_cmd_in, calc_ifc1.req1_data_in, calc_ifc1.req1_tag_in,
    calc_ifc1.req2_cmd_in, calc_ifc1.req2_data_in, calc_ifc1.req2_tag_in,
    calc_ifc1.req3_cmd_in, calc_ifc1.req3_data_in, calc_ifc1.req3_tag_in,
    calc_ifc1.req4_cmd_in, calc_ifc1.req4_data_in, calc_ifc1.req4_tag_in,
    calc_ifc1.reset,
    calc_ifc1.scan_in);

  test test_program(calc_ifc1);

endmodule
