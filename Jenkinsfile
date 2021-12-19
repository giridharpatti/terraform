pipeline{
  agent any
  stages{
    stage('terraform init'){
      steps{
        sh "terraform init -reconfigure"
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
        sh "mv terraform.state terraform-${tfvarfilename}.${BUILD_NUMBER}.state"
        sh "aws s3 cp terraform-${tfvarfilename}.${BUILD_NUMBER}.state s3://giriterraform/tfstate/terraform-${tfvarfilename}.${BUILD_NUMBER}.state"
      }
    }
  }
}
