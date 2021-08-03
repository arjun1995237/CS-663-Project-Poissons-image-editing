# Poisson's image editing -DIP
Some cool results are shown below.

![alt text](https://github.com/arjun1995237/CS-663-Project-Poissons-image-editing/blob/main/poisson_result1.jpg?raw=true)

![alt text](https://github.com/arjun1995237/CS-663-Project-Poissons-image-editing/blob/main/poisson_result2.jpg?raw=true)

![alt text](https://github.com/arjun1995237/CS-663-Project-Poissons-image-editing/blob/main/poisson_result4.jpg?raw=true)

![alt text](https://github.com/arjun1995237/CS-663-Project-Poissons-image-editing/blob/main/poisson_result5.jpg?raw=true)

Function is as called as follows

[edited_image,sourceOnlyOnTarget,sourcePlusDomegaOnTarget,maskSourceOnlyAllignedTarget]=preprocessing(image,source,iter=100,mix_grad=0);

edited_image is the result of editing ;
image =image on which we perform editing (RGB)
source =cropped  part to be placed seamlessly (RGB);make sure that it's not to big,as it wil result in larger matrix to be solved
iter= number of iteration for pcg to converge
mix_grad =1 ---we will take for greater of the two gradient (grad g or grad f*) while solving discrete poisson equation 
	 =0----we will only take the gradient from the source
	 
------------------------------------------------------------
While running the code,a window will pop out asking where to place the source ; make sure that the source is placed well within the target boundries;
Sources center with coincide with the point where you click on the target image(ie image)
