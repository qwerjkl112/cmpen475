`define CLK_PERIOD 10

interface calc_ifc(input bit clk);
  
  logic [0:31] out_data1, out_data2, out_data3, out_data4;
  logic [0:1] out_resp1, out_resp2, out_resp3, out_resp4;

  logic scan_out;

  logic [0:3] error_found;  
  
  logic [0:3] req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
  logic [0:31] req1_data_in, req2_data_in, req3_data_in, req4_data_in;

  logic [1:7] reset;
  logic scan_in;

  // Now, we're using a clocking block in our interface.
  clocking cb @(posedge clk);
    input out_data1, out_data2, out_data3, out_data4,
    out_resp1, out_resp2, out_resp3, out_resp4, 
    scan_out; 

    output error_found, 
    req1_cmd_in, req1_data_in, 
    req2_cmd_in, req2_data_in, 
    req3_cmd_in, req3_data_in,
    req4_cmd_in, req4_data_in, 
    scan_in;
  endclocking

  modport TEST_PROGRAM(clocking cb, output reset); 
    
endinterface

// TODO: Making this randomizable should be pretty easy!
// Represents a single request into the calculator.
class Request;
  logic [0:3] cmd;
  bit [0:31] operand1, operand2;

  function new(input logic [0:3] cmd, logic [0:31] operand1, operand2);
    this.cmd = cmd;
    this.operand1 = operand1;
    this.operand2 = operand2;
  endfunction
endclass

class RequestRand;
  rand bit [0:3] cmd;
  rand bit [0:31] operand1, operand2, operand3, operand4, operand5, operand6, operand7, operand8;

  constraint c {
		operand1<10 && operand2<10 && operand3<10 && operand4<10 ;
		operand5<10 && operand6<10 && operand7<10 && operand8<10 ;
		cmd==1;
  }
endclass
//my class
class MyRand;
  rand bit [0:3] cmd;
  rand bit [0:31] operand1, operand2, operand3, operand4, operand5, operand6, operand7, operand8;

  constraint c {
    cmd inside {1,2,5,6};
  }
endclass

class Randomtimelapse;
  randc bit [0:3] time;
endclass

// This program generates a queue of Requests and puts them into the calculator
// one-by-one, computing the expected output for each and checking it against
// the actual output.
program automatic test(calc_ifc.TEST_PROGRAM calc_ifc1);
  RequestRand request_queue[$];
  RequestRand req;
  logic [0:31] expected_output;
  logic valid_cmd;
  int number_of_tests=20;
  int clock_count=1;
  logic Responsed1, Responsed2, Responsed3, Responsed4;

  myRand myreq; 

  initial begin 

    // TODO: Create a Generator class to handle command generation.
    // Set up our task queue
    for (int i=1;i<=number_of_tests;i++) begin
    	req = new();
    	if(!req.randomize()) $finish;
    	request_queue.push_back(req);
    end

    while (request_queue.size() != 0) begin
	
    	// Reset device
	  $display("\n\nResetting device...");
    	calc_ifc1.reset <= 7'b1111111;
    	repeat (7) @calc_ifc1.cb;
    	calc_ifc1.reset <= 0;

      req = request_queue.pop_front();
      
      // Put the request on the wire.
      @calc_ifc1.cb;

    //first test each port with addition (this is my old test) 
    //The only way for me to test each port is to copy and paste this 4 times for each port. Unsure how to do this with class
    for(int i = 0; i < 100; i++) begin
      myreq = new();
      if(!req.randomize()) $finish;
      request_queue.push_back(req);
    end
    for(int i = 0; i < 25; i++) begin
      RequestRand req;
      req = request_queue.pop_front();
      @calc1_ifc1.cb;
      calc1_ifc1.cb.req1_cmd_in <= myreq.cmd;
      calc1_ifc1.cb.req1_data_in <= myreq.operand1;
      @calc1_ifc1.cb;
      calc1_ifc1.cb.req1_cmd_in <= 0;
      calc1_ifc1.cb.req1_data_in <= myreq.operand2;
      
      @(calc1_ifc1.cb.out_resp1);
      $display("response from port1");
      
      if(myreq.cmd == 1) begin
        if(calc_ifc1.cb.out_resp1 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data1 == myreq.operand1 + myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data1, myreq.operand1 + myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp1 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data1, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 2) begin
        if(calc_ifc1.cb.out_resp1 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data1 == myreq.operand1 - myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data1, myreq.operand1 - myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp1 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data1, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 5) begin
        if(calc_ifc1.cb.out_resp1 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data1 == myreq.operand1 << myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data1, myreq.operand1 << myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp1 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data1, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 6) begin
        if(calc_ifc1.cb.out_resp1 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data1 == myreq.operand1 >> myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data1, myreq.operand1 >> myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp1 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data1, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end //test for port 1
    end
    for(int i = 0; i < 25; i++) begin
      RequestRand req;
      req = request_queue.pop_front();
      @calc1_ifc1.cb;
      calc1_ifc1.cb.req2_cmd_in <= myreq.cmd;
      calc1_ifc1.cb.req2_data_in <= myreq.operand1;
      @calc1_ifc1.cb;
      calc1_ifc1.cb.req2_cmd_in <= 0;
      calc1_ifc1.cb.req2_data_in <= myreq.operand2;
      
      @(calc1_ifc1.cb.out_resp2);
      $display("response from port1");
      
      if(myreq.cmd == 1) begin
        if(calc_ifc1.cb.out_resp2 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data2 == myreq.operand1 + myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data2, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data2, myreq.operand1 + myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp2 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data2, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data2, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 2) begin
        if(calc_ifc1.cb.out_resp2 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data2 == myreq.operand1 - myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data2, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data2, myreq.operand1 - myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp2 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data2, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data2, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 5) begin
        if(calc_ifc1.cb.out_resp2 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data2 == myreq.operand1 << myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data2, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data2, myreq.operand1 << myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp2 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data2, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data2, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 6) begin
        if(calc_ifc1.cb.out_resp2 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data2 == myreq.operand1 >> myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data2, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data2, myreq.operand1 >> myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp2 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data2, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data2, req.operand1, req.operand2, req.cmd);
          continue;
        end
       //test for port 2
    end
    for(int i = 0; i < 25; i++) begin
      RequestRand req;
      req = request_queue.pop_front();
      @calc1_ifc1.cb;
      calc1_ifc1.cb.req3_cmd_in <= myreq.cmd;
      calc1_ifc1.cb.req3_data_in <= myreq.operand1;
      @calc1_ifc1.cb;
      calc1_ifc1.cb.req3_cmd_in <= 0;
      calc1_ifc1.cb.req3_data_in <= myreq.operand2;
        
      @(calc1_ifc1.cb.out_resp3);
      $display("response from port1");
        
      if(myreq.cmd == 1) begin
        if(calc_ifc1.cb.out_resp3 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data3 == myreq.operand1 + myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data3, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data3, myreq.operand1 + myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp3 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data3, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data3, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 2) begin
        if(calc_ifc1.cb.out_resp3 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data3 == myreq.operand1 - myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data3, req.cmd);
            else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data3, myreq.operand1 - myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp3 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data3, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data3, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 5) begin
        if(calc_ifc1.cb.out_resp3 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data3 == myreq.operand1 << myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data3, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data3, myreq.operand1 << myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp3 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data3, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data3, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 6) begin
        if(calc_ifc1.cb.out_resp3 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data3 == myreq.operand1 >> myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data3, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data3, myreq.operand1 >> myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp3 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data3, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data3, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end //test for port 3
    end
    for(int i = 0; i < 25; i++) begin
      RequestRand req;
      req = request_queue.pop_front();
      @calc1_ifc1.cb;
      calc1_ifc1.cb.req4_cmd_in <= myreq.cmd;
      calc1_ifc1.cb.req4_data_in <= myreq.operand1;
      @calc1_ifc1.cb;
      calc1_ifc1.cb.req4_cmd_in <= 0;
      calc1_ifc1.cb.req4_data_in <= myreq.operand2;
      
      @(calc1_ifc1.cb.out_resp4);
      $display("response from port1");
      
      if(myreq.cmd == 1) begin
        if(calc_ifc1.cb.out_resp4 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data1 == myreq.operand1 + myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data1, myreq.operand1 + myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp4 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data1, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data1, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 2) begin
        if(calc_ifc1.cb.out_resp4 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data4 == myreq.operand1 - myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data4, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data4, myreq.operand1 - myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp4 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data4, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data4, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 5) begin
        if(calc_ifc1.cb.out_resp4 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data4 == myreq.operand1 << myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data4, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data4, myreq.operand1 << myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp4 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data4, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data4, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end
      if(myreq.cmd == 6) begin
        if(calc_ifc1.cb.out_resp4 == 1) begin
          $display("output is successfully");
          assert(calc_ifc1.cb.out_data4 == myreq.operand1 >> myreq.operand2)
            $display("Operation succeeded! Operands: %0d, %0d; output: %0d; command: %0b.", 
            req.operand1, req.operand2, calc_ifc1.cb.out_data4, req.cmd);
          else $error("Operation failed! Output: %0d. Expected %0d. (Operands: %0d, %0d; command: %0b)",
            calc_ifc1.cb.out_data4, myreq.operand1 >> myreq.operand2, req.operand1, req.operand2, req.cmd);
        end
        if(calc_ifc1.cb.out_resp4 == 2)
          $display("an overflow or underflow has been detected, Operands: %0d, %0d,; output: %0d, command: %0b", req.operand1, req.operand2, calc_ifc1.cb.out_data4, req.cmd);
        else begin
          $error("INVALID command NOT detected! Output: %0d. (Operands: %0d, %0d; command: %0b)",
          alc_ifc1.cb.out_data4, req.operand1, req.operand2, req.cmd);
          continue;
        end
      end //test for port 4
    end

    $finish;

  end
endprogram

module testbench();
  
  bit clk;

  initial clk = 0;
  always #(`CLK_PERIOD/2) clk = !clk;

  calc_ifc calc_ifc1(clk);

  calc1_top calc(
    calc_ifc1.out_data1, calc_ifc1.out_data2, calc_ifc1.out_data3, calc_ifc1.out_data4,
    calc_ifc1.out_resp1, calc_ifc1.out_resp2, calc_ifc1.out_resp3, calc_ifc1.out_resp4,
    calc_ifc1.scan_out,
    // Note: the design has three clocks, but we'll just connect them all to one clock
    // for now.
    clk, clk, clk,
    calc_ifc1.error_found, 
    calc_ifc1.req1_cmd_in, calc_ifc1.req1_data_in, 
    calc_ifc1.req2_cmd_in, calc_ifc1.req2_data_in, 
    calc_ifc1.req3_cmd_in, calc_ifc1.req3_data_in, 
    calc_ifc1.req4_cmd_in, calc_ifc1.req4_data_in, 
    calc_ifc1.reset, 
    calc_ifc1.scan_in);

  test test_program(calc_ifc1);

endmodule
