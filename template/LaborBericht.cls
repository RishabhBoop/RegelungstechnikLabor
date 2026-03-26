%----------------------------------------------------------------------------------------
%   CLASS CONFIGURATION
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{LaborBericht}[2025/03/29 HKA Laborbericht Klasse v2.0]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions\relax

\LoadClass{extarticle}

%----------------------------------------------------------------------------------------
%   REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

%% ---- Document Structure Packages ---- %%
\RequirePackage{geometry}
\RequirePackage{titlesec}
\RequirePackage{titletoc}
\RequirePackage{float}
\RequirePackage{enumitem}
\RequirePackage[section]{placeins}
\RequirePackage{fancyhdr}
\RequirePackage{caption}

%% ---- Font and Typography Packages ---- %%
\RequirePackage{fontspec}
% \RequirePackage{microtype}
\RequirePackage[protrusion=true, expansion=true, final]{microtype}
\RequirePackage[ngerman]{babel}
\RequirePackage{csquotes}
\RequirePackage{setspace}

% =======================================================================
%  FONT CONFIGURATION
% =======================================================================

% Allow passing a templateDir macro if main .tex file defines it. Otherwise default to ../template
\providecommand{\templateDir}{../template}

% 1. Main Text Font (Serif)
\setmainfont{IBMPlexSerif}[
    Path = \templateDir/fonts/IBMPlexSerif/,
    Extension = .ttf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
    ItalicFont = *-Italic,
    BoldItalicFont = *-BoldItalic
]

% 2. Headers Font (Sans Serif)
\setsansfont{IBMPlexSans}[
    Path = \templateDir/fonts/IBMPlexSans/,
    Extension = .ttf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
    ItalicFont = *-Italic,
    BoldItalicFont = *-BoldItalic
]

% 3. Title Page Logo Font (Avant Garde alternative)
\newfontfamily\avantstyle{AVGARD}[
    Path = \templateDir/fonts/AvantGarde/,
    Extension = .TTF,
    UprightFont = *N_2,
    BoldFont = *D_2,
    ItalicFont = *DO_2
]
\DeclareTextFontCommand{\avantfont}{\avantstyle}

% Math font
\RequirePackage{unicode-math}
\setmathfont{Latin Modern Math} % Fallback math font for lualatex

% Fix Paragraph Spacing
\RequirePackage{parskip}         % New way (smart spacing)

% =======================================================================

%% ---- Graphics and Color Packages ---- %%
\RequirePackage{graphicx}
\RequirePackage{subcaption}
\RequirePackage{xcolor}
% \RequirePackage[table]{xcolor}
\RequirePackage{pgfplots}
\RequirePackage[european, straightvoltages, RPvoltages]{circuitikz}
\RequirePackage{tikz}
\RequirePackage{pgfplotstable}
\RequirePackage{booktabs}
\usetikzlibrary{calc}

%% ---- Math and Technical Packages ---- %%
\RequirePackage{amsmath}
\RequirePackage{siunitx}
\RequirePackage{esdiff}

%% ---- Hyperlinks ---- %%
\RequirePackage{hyperref}

%% ---- Conditional Packages ---- %%
\RequirePackage{pgffor} % for loops
\RequirePackage{ifthen}
\RequirePackage[colorinlistoftodos]{todonotes} % For TODO notes

%----------------------------------------------------------------------------------------
%   HYPERREF CONFIGURATION
%----------------------------------------------------------------------------------------
\AtBeginDocument{
    \hypersetup{
        pdftitle={\@title},
        pdfauthor={\@author},
        pdfsubject={\@berichttyp},
        pdfkeywords={HKA, Labor, \@title},
        colorlinks=false,      % Professional: No colored boxes around links
        linkcolor=black,
        citecolor=black,
        urlcolor=black
    }
}

%----------------------------------------------------------------------------------------
%   PACKAGE CONFIGURATION
%----------------------------------------------------------------------------------------

% Graphics configuration
\graphicspath{{Figures/}{Pictures/}{./}{images/}}

% Font command definitions
\newcommand{\bfsf}[1]{\textbf{\textsf{#1}}}
\RequirePackage{moresize}
\onehalfspacing

% List configuration
\setlist{partopsep=0pt, topsep=0pt, nolistsep}
\renewcommand{\labelenumi}{\alph{enumi}.}

% SIunitx configuration
\sisetup{locale=DE}

%----------------------------------------------------------------------------------------
%   COLORS
%----------------------------------------------------------------------------------------
\definecolor{ThemeColor}{RGB}{40,135,50}
\definecolor{firstColor}{HTML}{483FAB}
\definecolor{secondColor}{HTML}{BFAE78}
\definecolor{thirdColor}{HTML}{F28627}
\definecolor{fourthColor}{HTML}{D95525}
\definecolor{fifthColor}{HTML}{730202}

%----------------------------------------------------------------------------------------
%   HEADER STYLING (MODERN & BLACK)
%----------------------------------------------------------------------------------------

% Fonts are Lato (Sans Serif)
\titleformat{\section}
{\Large\bfseries\sffamily} % Format (Sans Serif)
{\thesection}
{1em}
{}

\titleformat{\subsection}
{\large\bfseries\sffamily}
{\thesubsection}
{1em}
{}

\titleformat{\subsubsection}
{\normalsize\bfseries\sffamily}
{\thesubsubsection}
{1em}
{}

%----------------------------------------------------------------------------------------
%   PAGE LAYOUT
%----------------------------------------------------------------------------------------
\geometry{
    paper=a4paper,
    top=3cm,
    bottom=3cm,
    left=3cm,
    right=3cm,
    headheight=14pt,
    footskip=2.4cm,
    headsep=10pt,
}

%----------------------------------------------------------------------------------------
%   TITLE PAGE VARIABLES
%----------------------------------------------------------------------------------------
\def\@matrikelnummer{}
\def\@betreuer{}
\def\@facultyname{Elektro- und Informationstechnik}
\def\@studiengang{Elektro- und Informationstechnik (Bachelor)}
\def\@berichttyp{Laborbericht}

\newcommand{\matrikelnummer}[1]{\def\@matrikelnummer{#1}}
\newcommand{\betreuer}[1]{\def\@betreuer{#1}}
\newcommand{\facultyname}[1]{\def\@facultyname{#1}}
\newcommand{\studiengang}[1]{\def\@studiengang{#1}}
\newcommand{\berichttyp}[1]{\def\@berichttyp{#1}}

%----------------------------------------------------------------------------------------
% CREATE TITLE PAGE
%----------------------------------------------------------------------------------------
\renewcommand{\maketitle}{%
    \begingroup % Keep changes local to the title page
    \thispagestyle{empty} % No headers or footers on this page
    \begin{tikzpicture}[remember picture, overlay]

        %%% --- Node Coordinates (adjust cm values for fine-tuning) --- %%
        \coordinate (HeaderTopLeft) at ($ (current page.north west) + (2, -2) $);
        \coordinate (FacultyPos) at ($ (HeaderTopLeft) + (0, -2) $);

        % Position logo anchor top-rightish
        \coordinate (H) at ($ (current page.north east) + (8, 0.8) $);
        \coordinate (K) at ($ (H) + (0,-8.6) $);
        \coordinate (A) at ($ (K) + (0,-8.6) $);

        % Positions for middle and lower text blocks
        \coordinate (StudiengangPos) at ($ (current page.north west) + (2cm, -10cm) $);
        \coordinate (BerichtTypPos) at ($ (StudiengangPos) + (0, -0.7cm) $);
        \coordinate (VersuchNamePos) at ($ (BerichtTypPos) + (0, -1.5cm) $);
        \coordinate (AutorenPos) at ($ (VersuchNamePos) + (0, -2.5cm) $);
        \coordinate (FooterPos) at ($ (current page.south west) + (2cm, 3.5cm) $); % Position near bottom-left

        %%% Text Blocks %%%
        % HKA, University of Applied Science
        \node[text width = 10cm, ThemeColor, below right] at (HeaderTopLeft) {
            \avantfont{\textbf{Hochschule Karlsruhe}}\\
            \avantfont{University of}\\
            \avantfont{Applied Sciences}};

        % Faculty Name
        \node[anchor=north west, text width=10cm, ThemeColor, below right] at (FacultyPos) {
            \avantfont{Fakultät für}\\
            \avantfont{\textbf{\@facultyname}}
        };

        % Studiengang / Bericht Typ
        \node[anchor=west, text width=15cm] at (StudiengangPos) {\avantfont{\@studiengang}};
        \node[anchor=west, text width=15cm] at (BerichtTypPos) {\avantfont{\@berichttyp}};

        % Main Title (VersuchName) - Large, Bold, Themed Color
        \node[anchor=west, text width=15cm, ThemeColor] at (VersuchNamePos) {
            \sffamily\bfsf{\Huge \@title} % Argument 4: VersuchName
        };

        % Authors Block
        \node[anchor=north west, text width=15cm, align=left] at (AutorenPos) {\avantfont{\@author}};

        % Footer Block (Matrikelnummer, Betreuer, Datum)
        \node[anchor=north west, text width=15cm, align=left] at (FooterPos) {%
            \begingroup
            \avantfont{\textbf{Matrikelnummer:} \@matrikelnummer} \\[2ex]
            \avantfont{\textbf{Betreuer: } \@betreuer} \\[2ex]
            \avantfont{\textbf{Datum:} \@date}
            \endgroup
        };


        %%% --- HKA Logo (Drawn using TikZ paths) --- %%%
        % Direct paths with attributes
        \path (H) [fill=ThemeColor, scale=0.45, rounded corners=1pt] +(0,-3) -- +(3,-3) -- +(3,0) -- +(4.2,0) -- +(4.2,-3) -- +(7.2,-3) -- +(7.2,-4) -- +(4.2,-4) -- +(4.2,-7) -- +(3,-7) -- +(3,-4) -- +(0,-4) -- cycle;
        % Vertical bar of H
        \path (H) [fill=ThemeColor, scale=0.45, rounded corners=1pt] +(7.8,0) -- +(9,0) -- +(9,-7) -- +(7.8,-7) -- cycle;
        % K shape
        \path (K) [fill=ThemeColor, scale=0.45, rounded corners=1pt] +(3, 0) -- +(4.2,0) -- +(4.2,-2.8) -- +(9,0) -- +(9,-1.3) -- +(5.2,-3.5) -- +(9,-5.6) -- +(9,-7) -- +(4.2,-4.1) -- +(4.2,-7) -- +(3,-7) -- cycle;
        % A shape
        \path (A) [fill=ThemeColor, scale=0.45, rounded corners=1pt] +(6, 0) -- +(6.65,0) -- +(10.05,-7) -- +(8.75,-7) -- +(6,-1.3) -- +(4.8,-3.7) -- +(7.52,-3.7) -- +(8.85,-4.8) -- +(4.3,-4.8) -- +(3.25,-7) -- +(1.95,-7) -- +(5.35,0) -- cycle;

    \end{tikzpicture}
    \cleardoublepage % Ensure content starts on the next page cleanly
    \endgroup
}

%----------------------------------------------------------------------------------------
%   TABLE OF CONTENTS
%----------------------------------------------------------------------------------------

% TOC depth configuration
\setcounter{tocdepth}{3} % Show up to subsubsections in TOC

% Section styling in TOC
\titlecontents{section}
[1.5em] % Indentation (Left Margin)
{\addvspace{0.5em}\sffamily\bfseries} % Font style
{\contentslabel{1.5em}} % Label width (e.g., "1.")
{}
{\titlerule*[0.5em]{.}\contentspage}

\titlecontents{subsection}
[3.8em] % Indentation (1.5 + 2.3)
{\addvspace{0.2em}\sffamily}
{\contentslabel{2.3em}} % Label width (e.g., "1.1")
{}
{\titlerule*[0.5em]{.}\contentspage}

\titlecontents{subsubsection}
[7.0em] % Indentation (3.8 + 3.2) -> Pushes text further right
{\addvspace{0.1em}\sffamily\small}
{\contentslabel{3.2em}} % Wider label for 3 digits (e.g., "1.10.5")
{}
{\titlerule*[0.5em]{.}\contentspage}

\titlecontents{figure}
[1.5em] % Indentation
{\addvspace{0.2em}\sffamily\small} % Format
{\figurename~\thecontentslabel:\space} % Format for the label
{} % Format for numberless entries
{\titlerule*[0.5em]{.}\contentspage} % Format for the page number

\titlecontents{table}
[1.5em] % Indentation
{\addvspace{0.2em}\sffamily\small} % Format
{\tablename~\thecontentslabel:\space} % Format for the label
{} % Format for numberless entries
{\titlerule*[0.5em]{.}\contentspage} % Format for the page number

%----------------------------------------------------------------------------------------
%	TABLE COMMAND
%----------------------------------------------------------------------------------------

% #1 = table caption
% #2 = table label
% #3 = CSV file path
% #4 = comma-separated list of column headers
\NewDocumentCommand{\createTable}{m m m m}{
    \begingroup
    % \catcode`_=12% Temporarily treat '_' as a normal character
    \begin{table}[H]
        \centering
        \pgfplotstabletypeset[
            col sep=comma, % Set column separator
            columns={#4}, % Specify columns to be displayed
            every head row/.style={
                    before row=\toprule, % Add a top rule before the header
                    after row=\midrule   % Add a midrule after the header
                },
            every column/.code={
                    \ifnum\pgfplotstablecol>0
                        \pgfkeysalso{column type/.add={|}{}}%
                    \fi
                },
            every head row cell/.style={
                    string type
                },
            header=true,    % Use first row as header
        ]{#3}
        \caption{#1}
        \label{#2}
    \end{table}
    \endgroup
}