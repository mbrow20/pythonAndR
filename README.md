# Using python in R shiny
<p>Here are some directions for running python in shiny. I thank ranikay for graciously providing an example.</p>

<ol>
  <li><strong> Open terminal in Mac and run these commands</strong> (<i>cd</i> is <i>change directory</i>. By running this script in Windows you may run into problems, e.g., Scripts/python rather than /bin/python. The project name should be the same as the folder name.)  </li>
  <blockquote>
    git clone https://github.com/mbrow20/pythonAndR.git <br>
    cd pythonAndR/ <br>
  </blockquote>
  <li>Install python packages via the terminal, including virtualenv.</li>
  <blockquote>
    pip install virtualenv <br>
    pip install numpy<br>
  </blockquote>
  <li>Open the pythonAndR.Rproj to open R. Install these packages when you're in RStudio.</li>
  <blockquote>
    install.packages("shiny") <br>
    install.packages("DT") <br>
    install.packages("RColorBrewer") 
    install.packages("reticulate") 
  </blockquote>
  <li>Open ui.R file in R. You can run the app locally in your computer to make sure it is running correctly. In the upper right corner of Rstudio there is a <span style="color:blue"><strong>Publish</strong></span></li>
  <blockquote>
    install.packages("shiny") <br>
    install.packages("DT") <br>
    install.packages("RColorBrewer") 
    install.packages("reticulate") 
  </blockquote>
</ol>


