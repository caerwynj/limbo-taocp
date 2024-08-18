/(nodes|items)\[/ && !/print/ {cnt += $2}
END{print cnt "mems"}
