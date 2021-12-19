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
        sh "mv /var/lib/jenkins/workspace/vpcterraform.state /var/lib/jenkins/workspace/vpcterraform-${tfvarfilename}.${BUILD_NUMBER}.state"
        sh "aws s3 cp /var/lib/jenkins/workspace/vpc/terraform-${tfvarfilename}.${BUILD_NUMBER}.state s3://giriterraform/tfstate/terraform-${tfvarfilename}.${BUILD_NUMBER}.state"
      }
    }
  }
}
