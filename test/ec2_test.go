package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestEC2instance(t *testing.T) {
	//creating terraformOptions with retryable errors 
	terraformOptions := terraform.WithDefaultRetryableErrors(t,&terraform.Options{
		TerraformDir: "../",
		
	})

	//tf destroy after completion
	defer terraform.Destroy(t,terraformOptions)

	//terraform init and apply 
	terraform.InitAndApply(t,terraformOptions)

	output := terraform.Output(t,terraformOptions,"ec2-instance-public-ip")

	url := fmt.Sprintf("http://%s:8080",output)

	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, World!", 5, 5*time.Second)
}
