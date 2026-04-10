# Revision: 4/10/26
# Description: Script to utilize the RAW printing port of a printer.

$printerIP = "192.168.131.8"
$port = 9100
$inputFolder = "X:\certificates"
$archiveFolder = "X:\archive"

# Opens and closes a connection to the printer.
function SendPDF {
    param(
        $printerIP,
        $file
    )

    
    $bytes = [System.IO.File]::ReadAllBytes($file)

    $client = New-Object System.Net.Sockets.TcpClient 
    $client.Connect($printerIP, $port)

    $stream = $client.GetStream()
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Flush()

    $stream.Close()
    $client.Close()
}

Write-Host "Running rawprinting... Certs will be automatically printed when generated..."

# Creates archive folder if not detected.
if(!(Test-Path $archiveFolder)) {
    New-Item -ItemType Directory -Path $archiveFolder | Out-Null
}
# Creates certificate folder if not detected.
if(!(Test-Path $inputFolder)) {
    New-Item -ItemType Directory -Path $inputFolder | Out-Null
}

# Loops to check if any new sanit. certs are in the certs folder, sends it to the printer and then moves it to the archive folder.
while ($true) {
    #if (Test-NetConnection $printerIP -Port $port){ 
        Get-ChildItem $inputFolder -Filter *.pdf | ForEach-Object {
            SendPDF -printerIP $printerIP -file $_.FullName
            Move-Item $_.Fullname $archiveFolder -Force
        }
    #}
    Start-Sleep -Seconds 5
}