# Verilog Language -> Basics

## 3 Simple wire
<details>
<summary>详情</summary>

构建一个电路，没有输入端口，只有一个输出端口，输出端口时钟驱动逻辑 1 ，即逻辑高。     

**分析**  
无。

**答案**  
```
module top_module( output one );

// Insert your code here
    assign one = 1'b1;

endmodule
```

</details>

## 2 Output Zero
<details>
<summary>详情</summary>

构建一个没有输入和一个输出的电路，输出一个常数 0。  

**分析**  
无。

**答案**  
```
module top_module(
    output zero
);// Module body starts after semicolon
	assign zero = 1'b0;
endmodule
```

</details>


