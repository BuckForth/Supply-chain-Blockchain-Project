$execPath = split-path -parent $MyInvocation.MyCommand.Definition

Write-Output "Generating Build and Test Output file @ $execPath\BuildTestOut.txt"
Write-Output "npm run build && npm run test" > "$execPath\BuildTestOut.txt"
npm run build >> "$execPath\BuildTestOut.txt"
npm run test >> "$execPath\BuildTestOut.txt"

Write-Output "Testing deployment to local network log: $execPath\deployLog.txt"
npm run deploy:local > "$execPath\deployLog.txt"

Write-Output "Testing deployment to local network log: $execPath\functionsLog.txt"
npm run testFunctions:local > "$execPath\functionsLog.txt"