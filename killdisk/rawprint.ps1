# Author: Dylan Haughton
# Revision: 3/30/26
# Description: Script to utilize the RAW printing port of a printer.




$printerIP = "192.168.131.8"
$port = 9100
$inputFolder = "D:\certificates"
$archiveFolder = "D:\archive"
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

if(!(Test-Path $archiveFolder)) {
    New-Item -ItemType Directory -Path $archiveFolder | Out-Null
}

while ($true) {
    if (Test-NetConnection $printerIP -Port $port){ 
        Get-ChildItem $inputFolder -Filter *.pdf | ForEach-Object {
            SendPDF -printerIP $printerIP -file $_.FullName
            Move-Item $_.Fullname $archiveFolder -Force
        }
    }
    Start-Sleep -Seconds 5
}

# Get-ChildItem $inputFolder -Filter *.pdf | ForEach-Object {
#     $file = $_.FullName
#     $destination = Join-Path $archiveFolder $_.Name

#     try {
#         Write-Host "Printing $($_.Name)"

#         SendPDF -printerIP $printerIP -file $file
#         Start-Sleep -Seconds 2

#         Move-Item $file $destination -Force

#         Write-Host "Moved to archive"
#     }
#     catch{
#         Write-Host "Failed to print $($_.Name)"
#         Write-Host $_
#     }
# }


