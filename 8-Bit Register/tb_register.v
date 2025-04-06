`timescale 1ns/100ps
`default_nettype none

module tb_register_file;
    parameter CLK_PERIOD = 10;

    reg clk, rst, we;
    reg [2:0] w_addr, r_addr1, r_addr2;
    reg [7:0] w_data;
    wire [7:0] r_data1, r_data2;

    register_file uut (
        .r_data1(r_data1),
        .r_data2(r_data2),
        .clk(clk),
        .we(we),
        .rst(rst),
        .w_addr(w_addr),
        .r_addr1(r_addr1),
        .r_addr2(r_addr2),
        .w_data(w_data)
    );

    // generate clock signal
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Test sequence
    initial begin
        rst = 1;
        we = 0;
        w_addr = 0;
        w_data = 0;
        r_addr1 = 0;
        r_addr2 = 0;

        #(CLK_PERIOD * 1.5) rst = 0;

        // Testing reset
        $display("[%0t]: reset test", $time);
        verify_read(0, 0, 0, 0);
        verify_read(7, 0, 0, 0);

        // Testing read/write
        $display("\n[%0t]: read/write test", $time);
        write_reg(1, 8'hA5);
        #1;
        verify_read(1, 0, 8'hA5, 8'h00);

        // Testing concurrent read ports
        $display("\n[%0t]: concurrent read ports test", $time);
        write_reg(2, 8'h3C);
        write_reg(3, 8'hF0);
        #1;
        verify_read(2, 3, 8'h3C, 8'hF0);

        // Testing write suppression (we=0)
        $display("\n[%0t]: write suppression test", $time);
        we = 0;
        w_addr = 1;
        w_data = 8'hFF;
        @(posedge clk);
        #1;
        verify_read(1, 0, 8'hA5, 0);

        // Testing address decoding
        $display("\n[%0t]: address decoding test", $time);
        test_all_addresses();

        // Testing timings
        $display("\n[%0t]: timing tests", $time);
        timing_tests();

        $display("\n[%0t] All tests completed", $time);
        $finish;
    end

    task write_reg;
        input [2:0] addr;
        input [7:0] data;
        begin
            we = 1;
            w_addr = addr;
            w_data = data;
            @(posedge clk);
            we = 0;
            $display("[%0t] Wrote 0x%h to register %0d", $time, data, addr);
        end
    endtask

    task verify_read;
		input [2:0] addr1;
		input [2:0] addr2;
		input [7:0] expected1;
		input [7:0] expected2;
		begin
			r_addr1 = addr1;
			r_addr2 = addr2;
			#1;
			if (r_data1 !== expected1 || r_data2 !== expected2) begin
				$error("[%0t] ERROR: r_addr1=%0d (got 0x%h, expected 0x%h) | r_addr2=%0d (got 0x%h, expected 0x%h)",
						$time, addr1, r_data1, expected1, addr2, r_data2, expected2);
			end else begin
				$display("[%0t] PASS: r_addr1=%0d=0x%h, r_addr2=%0d=0x%h",
						$time, addr1, r_data1, addr2, r_data2);
			end
		end
	endtask

    task test_all_addresses;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                write_reg(i, 8'h10 + i);
                #1;
                verify_read(i, 0, 8'h10 + i, 8'h00);
            end
        end
    endtask

    task timing_tests;
        begin
            w_data = 8'hAA;
            w_addr = 0;
            we = 1;
            #(CLK_PERIOD - 2); // Too close to clock edge
            @(posedge clk);
            #1;
            verify_read(0, 0, 8'h10, 0); // Should not change

            // Correct timing rate
            #(CLK_PERIOD / 4);
            w_data = 8'hBB;
            @(posedge clk);
            #1;
            verify_read(0, 0, 8'hBB, 0);
        end
    endtask

    initial begin
        $dumpfile("sim_register.vcd");
        $dumpvars(0, tb_register_file);
    end
endmodule
