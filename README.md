# Main repo for MOSAIC Calculus book

This repository is a Bookdown project that contains only some introductory material for the book.

The body of the book is contained in six sub-directories: Block-1 through Block-6. Each of these six directories is a Bookdown project on its own, containing the chapters, exercises, www-images, etc. for the corresponding block of the complete book.

To edit the individual blocks, open the relevant sub-directory by accessing the relevant RStudio `.Rproj` file, e.g.` Block-3.Rproj`.

After editing, compile that Block as a stand-alone Bookdown directory. The HTML files will be placed in a subdirectory with a name like `block-3`, under the `Block-3` main directory for that block.

To deploy, move the relevant HTML files from the subdirectory into the subdirectory of the same name in the `docs/` directory of the top-level project.  Remember, move only the HTML (and CSS, etc. if that's changed). DO NOT move the `Rmd` documents, which should stay in the `Block-[n]` directory.  
