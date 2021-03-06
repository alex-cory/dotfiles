CSS Organization
================

In A Nutshell
-------------




Alphabetize your property-value pairs -> it's a system everybody can recognize


Use indenting
  to
    denote
      hierarchy

Order your rules to a defined system -> AND STICK TO IT!

Detail that system at the top of the file -> Provide a table of contents


-- id's : identify

-- classes : clasify

ex: <li class = 'designer' id = 'Alex'>Alex Cory</li>


Use the cascade.
	Be specific only when necessary.
	This will simplify your css.

Understand css specificity
	Helps when working with someone else's code.

ex: a || b || c || d = specificity

	inline || IDs || (pseudo-) classes/attributes || elements

	li#Alex
	0 inline || 1 ID || 0 classes || 1 element = 0101

	li.designer
	0 inline || 0 ID || 1 classes || 1 element = 0011

Use shorthand properties where possible.

ex:  
```css
body {
	margin-top: 20px;
	margin-right: 20px;			       <- Avoid
	margin-bottom: 20px;
	margin-left: 20px;
}

body { margin: 20px } 				       <- preferred

!important   					       <- Avoid (whenever possible)
```

Avoid complex selectors. Try to be only as specific as needed.

ex:  
```css
.nav ul li a { margin: 0; }				<- Avoid
.nav a { margin: 0; } 					<- Preferred
```

Avoid IDs where ever possible.  Use classes instead.
Avoid using too many font-size declarations.




TOOLS for Formatting, Oranizing and Tidying CSS Code: 
----------------------------------------------------  
[Article:](http://goo.gl/DCq7Eu)
- [CSScomb](http://csscomb.com/) - The Greatest tool for sorting CSS properties in specific order
- [Helium](https://github.com/geuis/helium-css) - javascript tool to scan your site and show unused CSS
- [CSS Lint](http://csslint.net/#results) - Helps Find Issues With Your CSS code




Navigating extensive stylesheets
--------------------------------  

For extensive or highly complex stylesheets, CSS comments can also be used to implement a “quick-jump” mechanism to facilitate easy navigation. By including a specific character within sectional comments, you provide a way to “jump” through the document by using your software’s inevitable “Find” feature. For example, with the following sectional comments dispersed throughout my stylesheet, it would be very easy to jump from one section to the next with a simple Find("=") command:

```css
/* ===GLOBAL=== */
.
.
.
/* ===PRIMARY=== */
.
.
.
/* ===HEADER=== */
.
.
.
/* ===SIDEBAR=== */
.
.
.
/* ===FOOTER=== */
.
.
.
```

When doing this, it is important to choose a navigational character that is not used elsewhere in your CSS document. You may also want to use a CSS comment to include an organizational directory near the top of the document, thereby facilitating quick and easy stylesheet navigation:


```
/* CSS DIRECTORY
	1. =GLOBAL
	2. =PRIMARY
	3. =HEADER
	4. =SIDEBAR
	5. =FOOTER
*/
```



You could even include a key character within specific comments and hacks. Although I have never seen anyone use this technique, it is easy to imagine how something like this would be useful:

```css
/* HACK DIRECTORY
	% box model hack
	$ targets safari
	& clearfix hack
	? targets IE 7
*/
```

..with the associated anchors also present within the comments themselves. The same line of thinking could be applied to nearly any important aspect of a stylesheet. Something like this would certainly help collaborators and clients understand and navigate the document.





Other uses for the comment 
--------------------------

Okay, the article is getting rather long, so I will try to wrap it up. Here are some other great ways to use comments to improve the informational value of your stylesheets..

Timestamp and document information
----------------------------------

An excellent way to stay organized on the team or network level, especially useful during periods of rapid collaboration or development. In addition to this example, check out the top several lines of just about any WordPress theme for an excellent “real-world” implementation.

```css
/* DOCUMENT INFORMATION
	- Document: Jukebox Theme
	- Version:  1.2.3
	- Client:   Fonzi Winkler
	- Author:   M. Gibbonz   
*/
```


Color and font information
--------------------------  
In an effort to streamline production and subsequent editing, I have adapted this excellent strategy for summarizing all of the colors and fonts used in the stylesheet. This practice has served me well on countless occasions.

```css
/* COLORS
	- default body text  #ffffcc
	- subtitle h2 text   #ff9900
	- form input borders #cc9933
	- default p text     #f0f0f0
	- pre borders        #ffff99
*/

/* FONTS
	- default body text  Arial, Helvetica Neue, Helvetica, sans-serif
	- subtitle h2 text   Garamond, Hoefler Text, Times New Roman, Times, serif
	- form input text    Cambria, Georgia, Times, Times New Roman, Times, serif
	- default p text     Copperplate Light, Copperplate Gothic Light, serif
	- pre and code       Consolas, Lucida Console, Monaco, monospace
*/
```


Ways to organize the code itself
--------------------------------  

```css
.content {
    /* css */
}
    .content div {
        /* css */
    }
    .content span {
        /* css */
    }
    .content etc {
        /* css */
    }

.header {
    /* css */
}
    .header etc {
        /* css */
    }
```

Resources
---------  
 - [Powerpoint](http://goo.gl/mk5WK5)

