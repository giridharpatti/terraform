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
  }
}
