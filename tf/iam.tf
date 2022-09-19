resource "aws_iam_group" "administrators" { # 사용자그룹 설정
  name = "administrators"
}

resource "aws_iam_user" "admin1" { # 사용자 설정
  name = "admin1"
}

resource "aws_iam_group_membership" "administrators-users" { # 사용자그룹과 사용자 연동
  name = "administrators-users"
  users = [
    aws_iam_user.admin1.name
  ]
  group = aws_iam_group.administrators.name
}


resource "aws_iam_group_policy" "my_developer_policy" { # 사용자 그룹 정책
  name = "my_administrators_policy"
  group = aws_iam_group.administrators.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
     }
    ]
  }
EOF
}
