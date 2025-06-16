interface interrupt_interface(input PCLK);

    // Interrupt Output
    logic IRQ;


	task wait_for_interrupt_assertion();
		@(posedge IRQ);
		//$display("@[%0t] ============================== Interrupt Asserted ==============================", $time);
	endtask

	task wait_for_interrupt_clear();
		@(negedge IRQ);
		//$display("@[%0t] ============================== Interrupt Cleared  ==============================", $time);
	endtask


endinterface


















































/*

	always begin
		@(posedge IRQ);
		interrupt_assertion();
		@(negedge IRQ);
		interrupt_clear();
	end
	
	
  	function void interrupt_assertion();
		->> intr_asserted;
		//$display("@[%0t] [INTR_INTF] ---------- Interrupt Asserted ----------", $time);
	endfunction

	function void interrupt_clear();
		->> intr_deasserted;
		//$display("@[%0t] [INTR_INTF] ---------- Interrupt Cleared  ----------", $time);
	endfunction


	task wait_for_interrupt_assertion();
		@(posedge IRQ);
		//@intr_asserted;
		//wait(intr_asserted.triggered);
	endtask

	task wait_for_interrupt_clear();
		@(negedge IRQ);
		//@intr_deasserted;		
		//wait(intr_deasserted.triggered);
	endtask
*/


