# Servidor HTTP simple para Museo del Automóvil VR
$port = 8000
$path = (Get-Location).Path

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "╔════════════════════════════════════════════════════════════════╗"
Write-Host "║          MUSEO DEL AUTOMÓVIL VR - Servidor Local             ║"
Write-Host "╚════════════════════════════════════════════════════════════════╝"
Write-Host ""
Write-Host "✓ Servidor ejecutándose en: http://localhost:$port" -ForegroundColor Green
Write-Host "  Archivo principal: http://localhost:$port/start.html"
Write-Host "  Museo: http://localhost:$port/museo-autos.html"
Write-Host ""
Write-Host "Presiona Ctrl+C para detener el servidor"
Write-Host ""

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $requestPath = $request.Url.LocalPath
        if ($requestPath -eq '/') {
            $requestPath = '/start.html'
        }

        $filePath = Join-Path $path $requestPath.Substring(1)

        if (Test-Path $filePath -PathType Leaf) {
            $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $fileBytes.Length
            
            # Detectar tipo de contenido
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($ext) {
                '.html' { $response.ContentType = 'text/html; charset=utf-8' }
                '.css' { $response.ContentType = 'text/css; charset=utf-8' }
                '.js' { $response.ContentType = 'text/javascript; charset=utf-8' }
                '.json' { $response.ContentType = 'application/json; charset=utf-8' }
                '.png' { $response.ContentType = 'image/png' }
                '.jpg' { $response.ContentType = 'image/jpeg' }
                '.gif' { $response.ContentType = 'image/gif' }
                '.svg' { $response.ContentType = 'image/svg+xml' }
                default { $response.ContentType = 'application/octet-stream' }
            }

            $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
        } else {
            $response.StatusCode = 404
            $response.StatusDescription = "Not Found"
            $errorMsg = [System.Text.Encoding]::UTF8.GetBytes("404 - Archivo no encontrado")
            $response.OutputStream.Write($errorMsg, 0, $errorMsg.Length)
        }

        $response.OutputStream.Close()
    }
} finally {
    $listener.Stop()
    $listener.Close()
}
