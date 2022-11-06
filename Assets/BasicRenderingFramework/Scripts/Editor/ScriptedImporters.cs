using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor.AssetImporters;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    [ScriptedImporter(1, "blocktree")]
    public class BlockTreeImporter : ScriptedImporter
    {
        public override void OnImportAsset(AssetImportContext ctx)
        {
            var text = "当前二进制文件内容概要：\n";
            var buffer = System.IO.File.ReadAllBytes(ctx.assetPath);
            var startIndex = 0;
            var _Depth = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var AllBlockNodesCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var mbytes = (float)buffer.Length / (1024 * 1024);
            var gbytes = (float)buffer.Length / (1024 * 1024 * 1024);
            text += $"\n区块树深度：{_Depth}\n所有节点数量：{AllBlockNodesCount}\n文件大小：{buffer.Length}B/{mbytes.ToString("f2")}M/{gbytes.ToString("f2")}G\n";

            TextAsset textAsset = new TextAsset(text);
            ctx.AddObjectToAsset("main text", textAsset);
            ctx.SetMainObject(textAsset);
        }
    }

    [ScriptedImporter(1, "vdatabase")]
    public class VegetationDatabaseImporter : ScriptedImporter
    {
        public override void OnImportAsset(AssetImportContext ctx)
        {
            var text = "当前二进制文件内容概要：\n";
            var buffer = System.IO.File.ReadAllBytes(ctx.assetPath);
            var dir = System.IO.Path.GetDirectoryName(ctx.assetPath);
            var startIndex = 0;
            var NextInstanceID = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var TotalDataCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var bytesLength = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var BlockVegetationDatasDatabaseFilepath = System.Text.Encoding.UTF8.GetString(buffer, startIndex, bytesLength); startIndex += bytesLength;
            bytesLength = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var BlockVegetationDatasDatabaseInfoFilepath = System.Text.Encoding.UTF8.GetString(buffer, startIndex, bytesLength); startIndex += bytesLength;
           
            var infobuffer = System.IO.File.ReadAllBytes(System.IO.Path.Combine(dir, BlockVegetationDatasDatabaseInfoFilepath));
            startIndex = 0;
            var BlockCount = BitConverter.ToInt32(infobuffer, startIndex); startIndex += sizeof(int);
            var BytesCount = BitConverter.ToInt64(infobuffer, startIndex); startIndex += sizeof(long);

            var fileStream = new System.IO.FileStream(System.IO.Path.Combine(dir, BlockVegetationDatasDatabaseFilepath), FileMode.Open);
            var fileStreamLength = fileStream.Length;
            var intbytes = new byte[sizeof(int)];
            fileStream.Read(intbytes, 0, intbytes.Length);
            var count = BitConverter.ToInt32(intbytes, 0);
            fileStream.Close();

            var mbytes = (float)buffer.Length / (1024 * 1024);
            var gbytes = (float)buffer.Length / (1024 * 1024 * 1024);
            var infombytes = (float)infobuffer.Length / (1024 * 1024);
            var infogbytes = (float)infobuffer.Length / (1024 * 1024 * 1024);
            var blockDatabasembytes = (double)fileStreamLength / (1024 * 1024);
            var blockDatabasegbytes = (double)fileStreamLength / (1024 * 1024 * 1024);

            text += $"\n下一个植被实例ID：{NextInstanceID}\n植被数据总量：{TotalDataCount}\n" +
                $"区块植被数据库存放文件路径：{BlockVegetationDatasDatabaseFilepath}\n"+
                $"区块植被数据库信息存放文件路径: {BlockVegetationDatasDatabaseInfoFilepath}\n"+
                $"文件大小：{buffer.Length}B/{mbytes.ToString("f2")}M/{gbytes.ToString("f2")}G\n\n" +
                $"区块植被数据对象数量: {BlockCount}\n" +
                $"区块植被数据库所占字节数: {BytesCount}\n" + 
                $"区块植被数据库信息文件大小：{infobuffer.Length}B/{infombytes.ToString("f2")}M/{infogbytes.ToString("f2")}G\n\n" +
                $"区块植被数据库中记录的区块植被数据对象数量：{count}\n" + 
                $"区块植被数据库文件大小：{fileStreamLength}B/{blockDatabasembytes.ToString("f2")}M/{blockDatabasegbytes.ToString("f2")}G\n";

            TextAsset textAsset = new TextAsset(text);
            ctx.AddObjectToAsset("main text", textAsset);
            ctx.SetMainObject(textAsset);
        }
    }

    [ScriptedImporter(1, "blockDatabaseInfo")]
    public class BlockVegetationDatasDatabaseInfoImporter : ScriptedImporter
    {
        public override void OnImportAsset(AssetImportContext ctx)
        {
            var text = "当前二进制文件内容概要：\n";
            var infobuffer = System.IO.File.ReadAllBytes(ctx.assetPath);
            var startIndex = 0;
            var BlockCount = BitConverter.ToInt32(infobuffer, startIndex); startIndex += sizeof(int);
            var BytesCount = BitConverter.ToInt64(infobuffer, startIndex); startIndex += sizeof(long);

            var infobytes = (float)infobuffer.Length / (1024 * 1024);
            var gbytes = (float)infobuffer.Length / (1024 * 1024 * 1024);
            text += $"\n区块植被数据对象数量: {BlockCount}\n" +
                $"区块植被数据库所占字节数: {BytesCount}\n" +
                $"文件大小：{infobuffer.Length}B/{infobytes.ToString("f2")}M/{gbytes.ToString("f2")}G\n";

            TextAsset textAsset = new TextAsset(text);
            ctx.AddObjectToAsset("main text", textAsset);
            ctx.SetMainObject(textAsset);
        }
    }

    [ScriptedImporter(1, "blockDatabase")]
    public class BlockVegetationDatasDatabaseImporter : ScriptedImporter
    {
        public override void OnImportAsset(AssetImportContext ctx)
        {
            var text = "当前二进制文件内容概要：\n";
            var fileStream = new System.IO.FileStream(ctx.assetPath, FileMode.Open);
            var fileStreamLength = fileStream.Length;
            var intbytes = new byte[sizeof(int)];
            fileStream.Read(intbytes, 0, intbytes.Length);
            var count = BitConverter.ToInt32(intbytes, 0);
            fileStream.Close();
            var mbytes = (double)fileStreamLength / (1024 * 1024);
            var gbytes = (double)fileStreamLength / (1024 * 1024 * 1024);
            text += $"\n区块植被数据对象数量: {count}\n" +
                $"文件大小：{fileStreamLength}B/{mbytes.ToString("f2")}M/{gbytes.ToString("f2")}G\n";

            TextAsset textAsset = new TextAsset(text);
            ctx.AddObjectToAsset("main text", textAsset);
            ctx.SetMainObject(textAsset);
        }
    }
}
