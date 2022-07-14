# Verification - Reading Simulations -> Finding bugs in code

## 159 Mux
<details>
<summary>详情</summary>

这个 8 位宽的 2 对 1 多路复用器不起作用。  
```
module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output out  );

    assign out = (~sel & a) | (sel & b);

endmodule
```

**分析**  
sel是一位， a,b是八位。。。  

**答案**  
```
module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out  );

    assign out = sel ? a : b;

endmodule
```

</details>

## 160 NAND
<details>
<summary>详情</summary>

这个三输入NAND（与非门）不起作用。  
您必须使用提供的 5 输入与门：  
`module andgate ( output out, input a, input b, input c, input d, input e );`

```
module top_module (input a, input b, input c, output out);//

    andgate inst1 ( a, b, c, out );

endmodule
```

**分析**  
这种写法要严格遵守次序。  

**答案**  
```
module top_module (input a, input b, input c, output out);//
    
	wire out_1;
    andgate inst1 ( out_1, a, b, c, 1'b1, 1'b1 );
    assign out = ~out_1;

endmodule
```

</details>

## 161 Mux
<details>
<summary>详情</summary>

这个 4 对 1 多路复用器不起作用。  
```
module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out  ); //

    wire mux0, mux1;
    mux2 mux0 ( sel[0],    a,    b, mux0 );
    mux2 mux1 ( sel[1],    c,    d, mux1 );
    mux2 mux2 ( sel[1], mux0, mux1,  out );

endmodule
```

为您提供了一个无错误的 2 对 1 多路复用器：  
```
module mux2 (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
);
```

**分析**  
sel的问题，这里题目也没说清楚，提交看了时序才明白。  

**答案**  
```
module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out  ); //

    wire [7:0] mux0, mux1;
    mux2 m0 ( sel[0],    a,    b, mux0 );
    mux2 m1 ( sel[0],    c,    d, mux1 );
    mux2 m2 ( sel[1], mux0, mux1,  out );

endmodule
```

</details>

## 162 Add - sub
<details>
<summary>详情</summary>

以下带有零标志的加减法器不起作用。  
```
module top_module ( 
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);//

    always @(*) begin
        case (do_sub)
          0: out = a+b;
          1: out = a-b;
        endcase

        if (~out)
            result_is_zero = 1;
    end

endmodule
```

**分析**  
零标志 -> out为0 -> out没有一个为1

**答案**  
```
module top_module ( 
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output result_is_zero
);//

    always @(*) begin
        case (do_sub)
          0: out = a+b;
          1: out = a-b;
        endcase
    end
    
    assign result_is_zero = |out ? 1'b0 : 1'b1;

endmodule
```

</details>

## 163 Case statement
<details>
<summary>详情</summary>

这个组合电路应该识别键 0 到 9 的 8 位键盘扫描码。它应该指示 10 种情况中的一种是否被识别（有效），如果是，则检测到哪个键。  
```
module top_module (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid=1 );//

     always @(*)
        case (code)
            8'h45: out = 0;
            8'h16: out = 1;
            8'h1e: out = 2;
            8'd26: out = 3;
            8'h25: out = 4;
            8'h2e: out = 5;
            8'h36: out = 6;
            8'h3d: out = 7;
            8'h3e: out = 8;
            6'h46: out = 9;
            default: valid = 0;
        endcase

endmodule
```

**分析**  
初值问题。。。  
细节。。。  

**答案**  
```
module top_module (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);//

    always @(*) begin
        out = 4'b0;
        valid = 1;
        case (code)
            8'h45: out = 0;
            8'h16: out = 1;
            8'h1e: out = 2;
            8'h26: out = 3;
            8'h25: out = 4;
            8'h2e: out = 5;
            8'h36: out = 6;
            8'h3d: out = 7;
            8'h3e: out = 8;
            8'h46: out = 9;
            default: valid = 0;
        endcase
    end

endmodule
```

</details>
