pipeline{
  agent any
  stages{
    stage('terraform init'){
      steps{
        sh "terraform init"
      }
    }
    stage('terraform plan'){
      steps{
        sh "terraform plan --var-file=${tfvarfilename}.tfvars"
      }
    }
     stage('terraform apply'){
      steps{
        sh "terraform apply --var-file=${tfvarfilename}.tfvars --auto-approve"
      }
    }
    stage('terraform statefile copy to s3'){
      steps{
        sh "mv /var/lib/jenkins/workspace/vpc/terraform.tfstate /var/lib/jenkins/workspace/vpc/terraform-${tfvarfilename}.${BUILD_NUMBER}.tfstate"
        sh "aws s3 mv /var/lib/jenkins/workspace/vpc/terraform-${tfvarfilename}.${BUILD_NUMBER}.tfstate s3://giriterraform/tfstate/terraform-${tfvarfilename}.${BUILD_NUMBER}.tfstate"
      }
    }
  }
}
