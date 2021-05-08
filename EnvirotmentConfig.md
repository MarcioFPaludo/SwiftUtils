# Evirotment Config

## Available Strings

* **Production Strings:** Any string diferent of **Develop Strings** and **Homolog Strings**;
* **Homolog Strings:** homolog, hml or homologation;
* **Develop Strings:**  develop, dev or development;

## Configuration

First, we need to add the key **Configuration** with the string value **$(CONFIGURATION)** in the **Custom iOS Target Properties** of the project's info.plist file.

![Drag Racing](Dragster.jpg)

Now we need to go to the project file and open the **Info** tab. Here we are going to duplicate the settings until we have a **Debug** and a **Release** for each of the environments we want to create. The configuration nome need contains one of the **Available Strings** values to match with the enviroment.   



After maked the configuration files. We need create a **Scheme** for each of the environments and set in the **Schemes** yours respective configure files. 



Concluding the scheme configuration, now we just need call **Environment.current** in the code and we go have an enum value that match with the current project scheme! Enjoy that!  

