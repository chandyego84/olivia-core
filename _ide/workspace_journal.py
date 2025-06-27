# 2025-06-12T11:03:21.004642900
import vitis

client = vitis.create_client()
client.set_workspace(path="ARM8")

vitis.dispose()

