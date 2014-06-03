## [v3.0.2]
* renamed toplevel executables with qt_ prefix

##[v3.0.1]
* uses local gems `j2r-jaccess` and `j2r-core`

##[v3.0.0]
* decomposed in _j2r-jaccess_, _j2r-core_ and _j2r-qt_
* DATA moved to environment variable

#[v3]

##[v2.3.1]

##[v2.3.0]
* 2.3.0.1 - 2.3.0.4 : ajout des opérations de colonnes : somme
* 2.3.0.5 - 2.3.0.7 : opérations statistiques : moyenne, variance, écart-type
* 2.3.0.8 : style corrections
* 2.3.0.9 : filter frame need buttongroup

##[v2], [v2.1], [v2.2]
#[v2]

##[v2.0.RC1]
* all known bugs fixed
* fake join for article_sage
* rebuilt several classes

##[v1.99.10]
* les filtres négatifs peuvent concerner le même champ
* conversion des maquettes v1

##[v1.99.9] [evolution2]
* il y a une icone (petite fleur)
* l'échantillon de maquette affiché ne change que lorsque la maquette a effectivement changé.
* lorsqu'on ferme la fenêtre alors que la maquette a été modifiée, il y a un warning.
* l'affichage est clarifié : on dit clairement ce qui est maquette et ce qui est rapport.
* l'audit des tiers contient maintenant un item "achats divers" => il faut charger le "template" 'achat'.
* dans le panneau "mailing", un quatrième format, "Liste de tiers", permet de sortir une simple liste => par homogénéité de la commande, cela fait un fichier .csv, mais c'est "du CSV sans C et sans S", donc en fait du fichier texte.
* les valeurs vides apparaîssent dans les menus et dans les fichiers comme des carrés vide utf-8.

##[v1.99.7]
* Bouquet

##[v1.99.6]
* new communication
* parametrizer
* yaml format for recipes

##[v1.99.5]
* new entry panel

##[v1.99.4]
* new export tri-frame panel

##[v1.99.3]
* full compare panel

## [v1.99.2]
* compare panel proto
* ordered sample
* new user directory

## [v1.99.1]
* data frame
* popups
* batch processor
* audits
* tableau de bord

## [v1.99.0]

### Internal
* New recipe/query_builder logic
* No more sources

### Gui
* Moving to Qt

### Still not changed
* batch_processor and tableau de bord

## [v1.2.1]
* merging routing in master
* merging routing in rose
* tagging

## [v1.2.0]
* Cleaning GUIs
* Mailing both in designer and reporter
* No more title games in Report
* new class Mailing_list (mailing_list.rb)

## [v1.1.6] branch routing
* mailing stack for reporter

## [v1.1.5] commit 9018

* bin / bat

## [v1.1.4]

* csv output for bundles
* tree\_builder => query\_builder

## [v1.1.3] merged

Auditer GUi with wild cards

## [v1.1.2] Easter

* Auditer proto

## [v1.1.1] Easter branch

* Source#build_for
* tableau de bord
* audit method

## [v1.1.0]

* Real file dialog

## [v1.0.4]

* Reports with columns in the given order

## [v1.0.3][v1.0.3a][v1.0.3b]

* redesigned with Calibri
* new batch reporter
* bugs in reporter and bundle

## [v1.0.2a]

* batch reporter

## [v1.0.2]

* speed up by cleaning the recipe window

## [v1.0.1]

* bug in recipe
* simplification of parameter stack

## [v1.0.0] Jacinthe rose

* macros visible in designer

# [v1]

## [v0.18.2]

* rebuil all interfaces modules

## [v0.18.1][v0.18.1a]

* New macro system

## [v0.18.0]

* Source designer

## [v0.17.3]

* no more select button in source-side
* fixed size
* fixed compare
* glob for loading

## [v0.17.2]

* design
* titles for split html reports
* cleaning bottom line fort parameter change

## [v0.17.1]

* sourcefiltering OK
* sort without accents
* real temp files

## [v0.17.0]

* column methods to reporter
* open csv / open html
* no more cleaning of columns

## [v0.16.4]

* fields moving up and down in designer
* no more automatic show
* optional show in html form
* delete recipe in reporter
* csv output converted to ansi ; quoted items

## [v0.16.3]

* common formatters
* pdf output for bundles
* html output for bundles

## [v0.16.2]

* sizes work for Mac
* got rid of win/darwin : all in User now

## [v0.16.1]

* introduced a User class, with configuration
* got rid of Logger
* cleaned dirty hack in parametrizer
* moved methods from win/darwin in show_methods

## [v0.16.0]

* totally rebuilt TreeBuilder
* Old TreeBuilder is parallel
* changes in recipe/tree_builder/parametrizer/tree
* "schema" n'existe plus : modif à connect, build_jaccess_tables et update
* nettoyé j2r.ini

## [v0.15.0]

* unique update method for database changes
* everything renamed from 'j2r' to 'j2r'

## [v0.14.3]

* Big renaming of modules Recipes/Reports/Interfaces
* Got rid of all base building code (superseded my mysql < file.sql)

## [v0.14.2]

* Refactoring
* bug in extended links
* proto for console processing

## [v0.14.1]

* Filtrage par VIDE / NON VIDE

## [v0.14.0]

* rename to JacintheReports
* json form for sources
* new json for recipes
* new names for user directories
* BUG in reporter : added  mini_run

## [v0.13.3]

* BUG macro
* Protection des explosions

## [v0.13.2]

* Rapports éclatés : sorties show et html

## [v0.13.1]

* Bundle pour rapports éclatés

## [v0.13.0]

* Troisième pannneau du designer
* Refactoring du designer
* Methodes communes au designer et au reporter

## [v0.12.4]

* class Table, refactoring Reports and Formatters

## [v0.12.3]

* class Source, refactoring Designer

## [v0.12.2]

* redesign / renommage du designer

## [v0.12.1]

* suppression des sources
* dialogue de sauvegarde
* renommage source_side / report_side

## [v0.12.0]

* Renommage total
* Séparation init/update

## [v0.11.4]

* logging for designer

## [v0.11.3]

* logging for recipe

## [v0.11.2]

* downcase sorting
* client loop for "payeur"

## [v0.11.1]

* parameters columns are excluded from operations
* user directories

## [v0.11.0]

* New designer

## [v0.10.5]

* Parameters in titles : OK

## [v0.10.4]

* rolling choices for filters !!!

## [v0.10.3]

* Protection for saving

## [v0.10.2]

* rolling menu for projects

## [v0.10.1]

* filtered values not in finals
* fixed reporter

## [v0.10.0]

* Internal viewer

## [v0.9.6]

* Recipe works also for reporting

## [v0.9.5]

* Recipe
* Macro in Recipe
* Designer does not use Reporter anymore

## [v0.9.4]

* Designer actions delegated to Reporter
* Macro management in Reporter

## [v0.9.3]

* full designer
* with four Modules

## [v0.9.2]

* designer saves sql form
* reporter minimalized
* reporter_old ...

## [v.0.9.1]

* parametrizer
* designer  => tree_builder
*  reporter => sql_builder
*  reporter cleaned

## [v.0.9.0]

* Tree produces sql, params moved in Reporter
* Macros in reporter

## [v.0.8.3]

* Delete columns in Report and ReporterGUI
* Split reports in Report

## [v0.8.2]

* Choice list for filtering values
* starters for Reporter and Designer

## [v0.8.1]

* Output methods in Reporter GUI
* limit in html show

## [v0.8.0]

* exit Reporting
* Tree cut in halves : Tree and Reporter

## [v0.7.5]

* title management in designer
* no more output in designer

## [v0.7.4]

* Comparator in report / reporter

## [v0.7.3]

* Parameters in reporter
* "Intelligent" gestion of parameter values

## [v0.7.2]

* Cross reports in Report class
* Cross reports in reporter GUI

## [v0.7.1]

* reeking and refactoring
* Reporter Shoes methods in specific modules
* reporter GUi with filtering and sorting

## [v0.7.0]

* Report => Formatters  module
* Reporter
* Reporting

## [v0.6.4]

* Builder => Designer (name collision)
* Designer Shoes methods in specific module
* filter and paramater entries in value node

## [v0.6.3]

* Shoes builder
* bug in build_extended_lists

## [v0.6.2]

* Report/Builder

## [v0.6.1]

* Fixed bug in tree traversal

## [v0.6.0]

* More composed joins : 120, more extended fields 852
* One more view
* Files.rb with all the constants
* joins_and_fields before model

## [v0.5.0]

* Error trapping and logging
* Node and Tree separated

## [v0.4.4]

* SMF::Client
* Tiers and Client + specs
* Instance methods included for Tiers and Client

## [v0.4.3]

* specs
* demo directory
* added view fields to fields.yaml

## [v0.4.2]

* metaprog !
* new files

## [v0.4.1]

* SMF:: models
* tests for automatic follow

## [v0.4.0]

* renaming and module restructuration
* OUTPUT directory
* pattern work again, without fill
* afnor method

## [v0.3.0]

* dossiers DATA
* rapports à paramètres
* Field yaml file

## [v0.2.2]

* nettoyage de tree.rb, gestion d'erreurs
* sortie pdf des rapports
* disparition de 'fill', 'client' et 'tiers' (boucles à cause des vues)

## [v0.2.1]

* association_list for yaml file, association_table for ruby uses
* sortie pdf

## [v0.2.0]

* reports : html
* JSON for trees
* filtering in nodes

## [v0.1.6]

* No more View in the previous for
* Tree and Node

## [v0.1.5]

* Maquette -> View
* Table -> Report
* View en Sequel

## [v0.1.4]

* module Jacinthe
* constante SMF::DATA
* Maquettes / Tables

## [v0.1.3]

* separate files for client and tiers
* test coverage is total for Jaccess exploitation files.

## [v0.1.2]

* Directory jaccess
* module Jaccess
* Added Jacinthe table for view and related association
* Fixed build_association and fill_base

## [v0.1.1]

* fill_base has parameter : base 'test' created
* spec files for connect, model, associations
* class Sage becomes Client

## [v0.1.0] [v0.0.10]

* SMF::Tiers and SMF::Sage

## [v.0.0.9]

* Formats
* specific base_building directory
* associations.rb file split in two files

## [v0.0.8a]

* file 'check.rb' to check configuration, models, associations, filterig and querying
* associations in yaml file

## [v0.0.7]

* fill method thru associations
*   (no more Record class)

## [v0.0.6]

* Associations built from sql files
*   (no more yaml table)

## [v0.0.5]

* Model classes created from tables

## [v0.0.4]

* class Record
* relations yaml table

## [v0.0.3]

* Sequel / Mysql2
* fichier de configuration
* errors.rb

## [v0.0.2]

* installé la base SMF
* installé mysql2

## [v0.0.1]

* Premiers essais
