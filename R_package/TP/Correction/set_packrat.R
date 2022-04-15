# initialisation
# préférable de répartir d'une session vide
packrat::init()

# snapshot (pas obligatoire après un init)
# mais utile quand on ajoute / supprime un package
packrat::snapshot()

# status
packrat::status()

# creation d'un bundle
packrat::bundle()


# unbundle
packrat::unbundle(bundle = "/home/benoit/bash_example/packrat/bundles/bash_example-2017-12-01.tar.gz", 
                  where = "/home/benoit/bash_unbundle/")
