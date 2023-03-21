resource "null_resource" "cmd1" {
  provisioner "local-exec" {
    command = "ls -l"
  }
}

resource "null_resource" "cmdP" {
  provisioner "local-exec" {
    interpreter = ["python", "-c"]
    environment = {
      ENV_VAR1 = "var1_content"
    }
    command = "print('hi from Py')"
  }
}
