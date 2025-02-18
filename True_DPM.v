`timescale 1ns / 1ps

// Main Module
module Dual_Port_RAM(
    input Clr, Clk, WeA, WeB, SPM,
    input [7:0] dinA, dinB,
    input [7:0] addrA, addrB,
    output reg [7:0] doutA, doutB
    );

integer loc = 0;

parameter RAM_Data_Width = 8, RAM_Loc = 256;

reg [RAM_Data_Width - 1 : 0] mem [RAM_Loc - 1 : 0];

always@(negedge Clk or posedge Clr)
begin

    if(Clr)
        begin
            for(loc = 0 ; loc < RAM_Loc ; loc = loc + 1 ) begin
                mem[loc] <= 8'b0;   end
            doutA <= 8'b0;
            doutB <= 8'b0;
        end
    else if(SPM)
        begin
            if(WeA) 
                mem[addrA] <= dinA;
            else if(!WeA)
                doutA <= mem[addrA];   
        end
    else if(!SPM)
        begin
            case({WeA,WeB})
                2'b11:  
                begin
                    if(addrA == addrB)  
                        mem[addrA] <= dinA; 
                    else if(addrA != addrB) 
                        begin
                            mem[addrA] <= dinA; 
                            mem[addrB] <= dinB;     
                        end
                end
                
                2'b10:  
                begin
                    mem[addrA] <= dinA;                            
                    doutB <= mem[addrB];                                           
                end
        
                2'b01:  
                begin
                    doutA <= mem[addrA];
                    mem[addrA] <= 8'b0;
                    mem[addrB] <= dinB; 
                end
              
                2'b00:  
                begin
                    doutA <= mem[addrA];
                    doutB <= mem[addrB];          
                end
                
                default:    
                begin 
                    doutA <= 8'b0;
                    doutB <= 8'b0;
                end
            endcase
        end    
end

endmodule
