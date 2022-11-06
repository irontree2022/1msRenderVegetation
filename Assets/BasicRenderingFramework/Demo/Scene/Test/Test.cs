using RenderVegetationIn1ms;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.UIElements;

public class Test : MonoBehaviour
{
    struct TestStruct
    {
        public bool testbool
        {
            get => _testbool != 0;
            set => _testbool = value ? 1 : 0;
        }
        public int _testbool;
        public float testfloat;
        public int testint;
        public static int stride => sizeof(int) + sizeof(float) + sizeof(int);
    }
    struct TestBounds
    {
        public Vector3 center;
        public Vector3 extents;

        public static int stride => sizeof(float) * 6;
        public override string ToString()
        {
            return $"center:{center}, extents:{extents}";
        }
    }

    public bool test;
    public ComputeShader TestComputeShader;

    private ComputeBuffer testBuffer;
    private ComputeBuffer testBoundsBuffer;
    private ComputeBuffer testBoundsResultBuffer;

    BlockTree blocktree;
    VegetationDatabase vegetationDatabase;
    void Start()
    {
        testBuffer = new ComputeBuffer(2, TestStruct.stride);
        var testStructs = new TestStruct[2];
        testBuffer.SetData(testStructs, 0, 0, 2);

        var testBoundsArr = new Bounds[64];
        for(var i = 0; i < testBoundsArr.Length; i++)
        {
            var testBounds = testBoundsArr[i];
            testBounds.center = Vector3.one;
            testBounds.extents = Vector3.one * 10;
            testBoundsArr[i] = testBounds;
        }
        testBoundsBuffer = new ComputeBuffer(testBoundsArr.Length, TestBounds.stride);
        testBoundsBuffer.SetData(testBoundsArr);
        testBoundsResultBuffer = new ComputeBuffer(testBoundsArr.Length, TestBounds.stride, ComputeBufferType.Append);

        TestComputeShader.SetInt("testBoundsBufferCount", testBoundsArr.Length);
        TestComputeShader.SetBuffer(0, "testBoundsBuffer", testBoundsBuffer);
        TestComputeShader.SetBuffer(0, "testBoundsResultBuffer", testBoundsResultBuffer);

        var filepath = "Assets/StreamingAssets/test.test";
        using (FileStream fs = new FileStream(filepath, FileMode.Create))
        {
            var binaryWriter = new BinaryWriter(fs, System.Text.Encoding.UTF8);
            binaryWriter.Write(64);
            binaryWriter.Write(12.5f);
            binaryWriter.Write(true);
            binaryWriter.Write(0.1f);
            binaryWriter.Close();
            binaryWriter.Dispose();
        }

        var dateTime = System.DateTime.Now;
        blocktree = new BlockTree();
        vegetationDatabase = new VegetationDatabase();
        blocktree.ReadFromFile("Assets/StreamingAssets/1msSerializedDatas/BlockTree.1ms.blocktree");
        var dtime = System.DateTime.Now - dateTime;
        Debug.Log($"[RenderVegetationIn1ms] 解析blocktree数据 耗时：{dtime.TotalSeconds}s, {dtime.TotalMinutes}m");
        dateTime = System.DateTime.Now;
        vegetationDatabase.ReadFromFile("Assets/StreamingAssets/1msSerializedDatas/VegetationDatabase.1ms.vdatabase");
        dtime = System.DateTime.Now - dateTime;
        Debug.Log($"[RenderVegetationIn1ms] 解析vegetationDatabase数据 耗时：{dtime.TotalSeconds}s, {dtime.TotalMinutes}m");
    }

    void Update()
    {
        if (test)
        {
            test = false;
            testBoundsResultBuffer.SetCounterValue(0);
            TestComputeShader.Dispatch(0, 1, 1, 1);
            var getTestBounds = new Bounds[64];
            testBoundsResultBuffer.GetData(getTestBounds);
            for (var i = 0; i < getTestBounds.Length; i++)
                Debug.Log($"{i}=> {getTestBounds[i]}");
        }   
    }

    private void OnDestroy()
    {
        testBuffer?.Release();
        testBoundsBuffer?.Release();
        testBoundsResultBuffer?.Release();
        blocktree = null;
        vegetationDatabase = null;
    }
}
