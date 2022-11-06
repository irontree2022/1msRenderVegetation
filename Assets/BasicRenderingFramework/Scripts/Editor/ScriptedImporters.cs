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
            var text = "��ǰ�������ļ����ݸ�Ҫ��\n";
            var buffer = System.IO.File.ReadAllBytes(ctx.assetPath);
            var startIndex = 0;
            var _Depth = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var AllBlockNodesCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var mbytes = (float)buffer.Length / (1024 * 1024);
            var gbytes = (float)buffer.Length / (1024 * 1024 * 1024);
            text += $"\n��������ȣ�{_Depth}\n���нڵ�������{AllBlockNodesCount}\n�ļ���С��{buffer.Length}B/{mbytes.ToString("f2")}M/{gbytes.ToString("f2")}G\n";

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
            var text = "��ǰ�������ļ����ݸ�Ҫ��\n";
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

            text += $"\n��һ��ֲ��ʵ��ID��{NextInstanceID}\nֲ������������{TotalDataCount}\n" +
                $"����ֲ�����ݿ����ļ�·����{BlockVegetationDatasDatabaseFilepath}\n"+
                $"����ֲ�����ݿ���Ϣ����ļ�·��: {BlockVegetationDatasDatabaseInfoFilepath}\n"+
                $"�ļ���С��{buffer.Length}B/{mbytes.ToString("f2")}M/{gbytes.ToString("f2")}G\n\n" +
                $"����ֲ�����ݶ�������: {BlockCount}\n" +
                $"����ֲ�����ݿ���ռ�ֽ���: {BytesCount}\n" + 
                $"����ֲ�����ݿ���Ϣ�ļ���С��{infobuffer.Length}B/{infombytes.ToString("f2")}M/{infogbytes.ToString("f2")}G\n\n" +
                $"����ֲ�����ݿ��м�¼������ֲ�����ݶ���������{count}\n" + 
                $"����ֲ�����ݿ��ļ���С��{fileStreamLength}B/{blockDatabasembytes.ToString("f2")}M/{blockDatabasegbytes.ToString("f2")}G\n";

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
            var text = "��ǰ�������ļ����ݸ�Ҫ��\n";
            var infobuffer = System.IO.File.ReadAllBytes(ctx.assetPath);
            var startIndex = 0;
            var BlockCount = BitConverter.ToInt32(infobuffer, startIndex); startIndex += sizeof(int);
            var BytesCount = BitConverter.ToInt64(infobuffer, startIndex); startIndex += sizeof(long);

            var infobytes = (float)infobuffer.Length / (1024 * 1024);
            var gbytes = (float)infobuffer.Length / (1024 * 1024 * 1024);
            text += $"\n����ֲ�����ݶ�������: {BlockCount}\n" +
                $"����ֲ�����ݿ���ռ�ֽ���: {BytesCount}\n" +
                $"�ļ���С��{infobuffer.Length}B/{infobytes.ToString("f2")}M/{gbytes.ToString("f2")}G\n";

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
            var text = "��ǰ�������ļ����ݸ�Ҫ��\n";
            var fileStream = new System.IO.FileStream(ctx.assetPath, FileMode.Open);
            var fileStreamLength = fileStream.Length;
            var intbytes = new byte[sizeof(int)];
            fileStream.Read(intbytes, 0, intbytes.Length);
            var count = BitConverter.ToInt32(intbytes, 0);
            fileStream.Close();
            var mbytes = (double)fileStreamLength / (1024 * 1024);
            var gbytes = (double)fileStreamLength / (1024 * 1024 * 1024);
            text += $"\n����ֲ�����ݶ�������: {count}\n" +
                $"�ļ���С��{fileStreamLength}B/{mbytes.ToString("f2")}M/{gbytes.ToString("f2")}G\n";

            TextAsset textAsset = new TextAsset(text);
            ctx.AddObjectToAsset("main text", textAsset);
            ctx.SetMainObject(textAsset);
        }
    }
}
