# Export certificates
If your VPN requires user certificates from a Windows system where the certificates are marked unexportable or private-key unexportable, run `exportrsa.exe` on the Windows system to extract needed certificates and put them in the `certs/` folder.

You'd be right to be suspicious of running `.exe` files made by a stranger, so if you don't trust this `.exe` you can use the original from the [ExportNotExportablePrivateKey](https://github.com/luipir/ExportNotExportablePrivateKey) repository where the source is also available. The result will be the same. I excluded my version of the source code because I don't want to manage Visual C++ source code in this repo.

This slightly improved `exportrsa.exe` differs from the original in that it
 - Statically links to MSVC dll so the user doesn't need to install anything extra.
 - It exports each certificate with its name as the file name, rather than a meaningless index number (original behavior).

