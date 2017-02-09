using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Searching.BE.Service
{
    public class Logger
    {
        static public void WriteToFile_Json(string json)
        {
            
            var plor = "This Json: " + json;
            var path= "C:\\Mail.ru\\projects\\Searching\\Sourse Code\\Searching.Solution\\Logg\\";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            string name = string.Format("Json at {0:t}", DateTime.Now.ToString().Replace(":", "."));
            string result = path + name;
            StreamWriter stream = new StreamWriter(result,true);
            stream.WriteLine(plor);
            stream.Close();
        }
        static private void Read_and_writeToFile_Exception(Exception e, string logFile)
        {
            if (e.InnerException != null)
            {
                Read_and_writeToFile_Exception(e.InnerException, logFile);
            }

            StreamWriter stream = new StreamWriter(logFile, true);
            stream.WriteLine("Ошибка: " + e.Message);
            stream.WriteLine("Объект: " + e.Source);
            stream.WriteLine("Метод, вызвавший исключение: " + e.TargetSite);
            stream.WriteLine("Стэк: " + e.StackTrace);
            stream.WriteLine("====================================");
            stream.Close();

        }

        static public void CreateLog(Exception e)
        {
            string path = @"C:\Mail.ru\projects\Searching\Sourse Code\Searching.Solution\Logg";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }

            string logFile = string.Format("\\{0:t}", DateTime.Now.ToString().Replace(":", "."));
            Read_and_writeToFile_Exception(e, path + logFile);

        }
    }
}