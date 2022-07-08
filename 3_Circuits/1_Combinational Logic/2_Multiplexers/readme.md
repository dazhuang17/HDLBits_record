# Circuits -> Combinational Logic -> Multiplexers

## 61 2-to-1 multiplexer
<details>
<summary>详情</summary>

创建一位宽的 2 对 1 多路复用器。当 sel=0 时，选择 a。当 sel=1 时，选择 b。  

**分析**  
写就完事了。。。  

**答案**  
```
module top_module( 
    input a, b, sel,
    output out ); 
    
    assign out = sel ? b : a;

endmodule
```

</details>

## 62 2-to-1 bus multiplexer
<details>
<summary>详情</summary>

创建一个 100 位宽的 2 对 1 多路复用器。当 sel=0 时，选择 a。当 sel=1 时，选择 b。  

**分析**  
写就完事了。。。

**答案**  
```
module top_module( 
    input [99:0] a, b,
    input sel,
    output [99:0] out );
    
    assign out = sel ? b : a;

endmodule
```

</details>

## 63 9-to-1 multiplexer
<details>
<summary>详情</summary>

创建一个 16 位宽的 9 对 1 多路复用器。 sel=0 选择 a，sel=1 选择 b，等等。对于未使用的情况（sel=9 到 15），将所有输出位设置为“1”。  


**分析**  
写就完事了。。。  

**答案**  
```
module top_module( 
    input [15:0] a, b, c, d, e, f, g, h, i,
    input [3:0] sel,
    output [15:0] out );
    
    always @(*) begin
        case(sel)
            3'd0: out = a;
            3'd1: out = b;
            3'd2: out = c;
            3'd3: out = d;
            3'd4: out = e;
            3'd5: out = f;
            3'd6: out = g;
            3'd7: out = h;
            4'd8: out = i;
            default: out = 16'hffff;
        endcase
    end

endmodule
```

</details>

## 64 256-to-1 multiplexer
<details>
<summary>详情</summary>

创建一个 1 位宽、256 对 1 的多路复用器。
256 个输入全部打包成一个 256 位输入向量。 sel=0 应该选择 in[0]，sel=1 选择 [1] 中的位，sel=2 选择 [2] 中的位，等。    

**分析**  
写就完事了。。。  

**答案**  
```
module top_module( 
    input [255:0] in,
    input [7:0] sel,
    output out );
    
    assign out = in[sel];

endmodule
```

</details>

## 65 256-to-1 4-bit multiplexer
<details>
<summary>详情</summary>

创建一个 4 位宽、256 对 1 的多路复用器。
256 个 4 位输入全部打包成一个 1024 位输入向量。
sel=0 应该选择[3:0] 中的位，sel=1 选择[7:4] 中的位，sel=2 选择[11:8] 中的位等。

**分析**  
算一下就好。  
in[ sel*4+3 : sel*4 ] 在Verilog会报错哦，不符合语法。
因此，采用in[sel * 4 +: 4]。  

**答案**  
```
module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );
    
    assign out = in[sel * 4 +: 4];

endmodule
```

</details>

