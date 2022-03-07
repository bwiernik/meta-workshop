options(repos = c(
  easystats = 'https://easystats.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'
))

install.packages(c(
  "easystats",
  "tidyverse",
  "psychmeta",
  "metafor",
  "robumeta"
))

# In RStudio, click Tools → Global Options…
#   1. On the first page, under **Workspace**:
#     - Uncheck *Restore .RData into workspace at startup*
#     - Set *Save workspace to .RData on exit* to *Never*
#   2. Under **History**:
#     - Uncheck *Always save history (even when not saving .RData)*
#   3. Click the **Advanced** button at the top. Under **Other**:
#     - Check *Show .Last.value in environment listing*
#
# Now, adjust the appearance of RStudio to your liking:
#
#   1. In the Pane Layout window, you can rearrange RStudio’s 4 panes.
#   2. In the Appearance window, you can change your font size, code typeface, and RStudio color scheme.
#     - I use the Tomorrow Night Bright color scheme.
#   3. In the Code window, you can change various ways about how code is inserted and shown.
#      Change 3 settings from their defaults:
#        - On the **Editing** page, under **General**, check *Use native pipe operator |> (requires R 4.1+)*
#        - On the **Editing** page, under **Execution** ,set *Ctrl/Cmd+Enter executes* to *Multiple consecutive R lines*
#        - On the **Display** page, check *Rainbow parentheses*
#   4. In the RMarkdown window, you can change how RMarkdown is shown while you edit it.
#     - Uncheck *Show output inline for all RMarkdown documents*.
#
# Go ahead and customize your RStudio appearance (color theme, font, etc.) and pane layout to whatever you find appealing.
# You can always come back and change these later until you find a setup you like.
