Bucket Policy:  
  
`{`
    `"Version": "2012-10-17",`
    `"Statement": [`
        `{`
            `"Effect": "Allow",`
            `"Principal": {`
                `"AWS": "arn:aws:iam::867102406853:root"`
            `},`
            `"Action": "s3:*",`
            `"Resource": [`
                `"arn:aws:s3:::cpy-temp-export-dynamodb/*",`
                `"arn:aws:s3:::cpy-temp-export-dynamodb"`
            `]`
        `}`
    `]`
`}`

Essa policy serve para que a bucket seja acessível por outra conta na AWS...  
A policy de exemplo permite que a conta STP PRD consiga ter acesso a essa Bucket presente na DLA PRD.

A parte em laranja faz referência a conta STP PRD, valide se será isso mesmo ou será outra conta, se for, terá que alterar

As partes em vermelho fazem referência a bucket que estou querendo que seja enxergada na outra conta, provavelmente terá que alterar isso