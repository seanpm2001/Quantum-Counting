﻿namespace QSharpExercises {
    

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Arrays;

    newtype Double2d = (rows: Int, cols : Int, vals: Double[]);
    

    //Tests if Prep is working (Manually check to see if its working)
    @Test("QuantumSimulator")
    operation TestPrep () : Unit {
        //For all lengths 1-5 and i's
        for length in 1..5{
            for i in 0..PowI(2,length)-1{
                //Create 2 registers
                use reg1 = Qubit[length];
                use reg2 = Qubit[length];
                //Prep in BigEndian and LittleEndian
                PrepBE(reg1,i);
                PrepLE(reg2,i);
                //Message Results
                let reg1M = MeasureAndMessage($"State is {i}, LE ",reg1,true);
                let reg2M = MeasureAndMessage($"State is {i}, BE ",reg2,true);
            }
        }
     }
	//Prep register into an integer state in LittleEndian
    operation PrepLE(reg: Qubit[],state: Int): Unit{
        let arr = BigIntAsBoolArray(IntAsBigInt(state));
        for i in 0..Length(arr)-1{
            if(arr[i]){
                X(reg[i]);
            }
        }
    }
    //Prep register into an integer state in BigEndian
    operation PrepBE(reg: Qubit[],state: Int): Unit is Ctl + Adj{
        let arr = BigIntAsBoolArray(IntAsBigInt(state));
        for i in 0..Length(arr)-1{
            if(arr[i]){
                X(reg[Length(reg)-1-i]);
            }
        }
    }
    //Reverse a register with swap gates
    operation Reverse(reg: Qubit[]):Unit{
        for i in 0..Length(reg)/2-1{
            SWAP(reg[i],reg[Length(reg)-i-1]);
        }
    }
    //Reverse a register with swap gates
    operation ReverseBoolArray(arr: Bool[]):Bool[]{
        mutable revArr = new Bool[0];
        for i in 0..Length(arr)-1{
            set revArr += [arr[Length(arr)-i-1]];
        }
        return revArr;
    }
    //Reverse a register with swap gates
    operation BoolArrayAsIntBE(arr: Bool[]):Int{
        return BoolArrayAsInt(ReverseBoolArray(arr));
    }
    //Apply in place XOR on reg1 and reg2 (results are in reg2)
    operation Xor(reg1: Qubit[],reg2: Qubit[]): Unit{
        for i in 0..Length(reg1)-1{
            CNOT(reg1[i],reg2[i]);
        }
    }
    //Creates a 2d Double array
    operation CreateDouble2d(rows: Int, cols : Int): Double2d{
        let arr = new Double[rows*cols];
        return Double2d(rows,cols,arr);
    }
    //Gets the value of 2d Double array at (i,j)
    operation GetDouble2d(i : Int, j : Int, double2d: Double2d):Double{
        let (rows,cols,arr) = double2d!;
        return arr[(cols*i)+j];

    }
    //Sets the value of 2d Double array at (i,j)
    operation SetDouble2d(i : Int, j : Int, val: Double, double2d: Double2d):Double2d{
        mutable (rows,cols,arr) = double2d!;
        set arr w/= ((i*cols)+j) <- val;
        return Double2d(rows,cols,arr);
    }
    //Meausure the register with a given name and output the results (only if debugging)
    operation MeasureAndMessage(name: String, reg: Qubit[], debug: Bool): Bool[]{
        if(debug){
            Message($"{name} is in state: ");
	    }
        let arr = ResultArrayAsBoolArray(MultiM(reg));
        mutable o = "";
        for a in arr{
            set o += a?"1"|"0";
        }
        if(debug){
            Message(o);
	    }
	
        return arr;
    }
    //Message the text if debugging
    operation MessageAndDebug(text: String, debug: Bool): Unit{
        if(debug){
            Message(text);
        }
    }
    //Copys register 1 into register 2
    operation Copy(reg1 : Qubit[], reg2 : Qubit[]): Unit is Ctl + Adj{
        for i in 0..Length(reg1)-1{
            CX(reg1[i], reg2[i]);
		}
    }
}
