module main #(parameter W = 8)
	(
		input clk, rst,
		input [W-1:0] in,
		input [3:0] op,
		input apply,

		output [W-1:0] head,
		output empty,
		output reg valid
	);

	reg [3:0] size;
	reg [W-1:0] stack [1:10];

	assign empty = size == 0;
	assign head = size >= 1 ? stack[size] : 0;
	

always @(posedge clk or posedge rst)
begin
	if(rst)
		begin
			size <= 0;
			valid <= 1;
		end 
	else
		begin
		if (apply)
			begin
				case(op)
				4'd0 :
				begin
					if (size < 4'd10)
						begin
							stack[size+1] <= in;
							size <= size + 1;
						end
					else
						begin
							valid <= 0;
						end
				end

				4'd1 :
				begin
				    if (size >= 1)
				    	begin
				    		size <= size - 1;
				    	end
				    else
				    	begin
				    		valid <= 0;
				    	end
				end

				4'd2 :
				begin
					if (size >= 1)
						begin
							stack[size] <= stack[size] + 1;
		                end
		            else
		            	begin
		            		valid <= 0;
		           		end
		        end

		        4'd3 :
		        begin
					if (size >= 1)
						begin
							stack[size] <= stack[size] - 1;
		                end
		            else
		            	begin
		            		valid <= 0;
		            	end
		        end

		        4'd4 :
		        begin
					if (size >= 2)
						begin
							stack[size-1] <= stack[size-1] + stack[size];
							size <= size - 1;
		                end
		            else
		            	begin
		            		valid <= 0;
		            	end
		        end

		        4'd5 :
		        begin
					if (size >= 2)
						begin
							stack[size-1] <= stack[size-1] - stack[size];
							size <= size - 1;
		                end
		            else
		            	begin
		            		valid <= 0;
		            	end
		        end

		        4'd6 :
		        begin
					if (size >= 2)
						begin
							stack[size-1] <= stack[size-1] * stack[size];
							size <= size - 1;
		                end
		            else
		            	begin
		            		valid <= 0;
		            	end
		        end

		        4'd7 :
		        begin
					if (size >= 2 && head != 0)
						begin
							stack[size-1] <= stack[size-1] / stack[size];
							size <= size - 1;
		                end
		            else
		            	begin
		            		valid <= 0;
		            	end
		        end

		        4'd8 :
		        begin
					if (size >= 2 && head != 0)
						begin
							stack[size-1] <= stack[size-1] % stack[size];
							size <= size - 1;
		                end
		            else
		            	begin
		            		valid <= 0;
		            	end
		        end

		        default:
		        begin
		        	valid <= 0;
		        end
		        
		        endcase
	    	end
	    end     
end
    
endmodule