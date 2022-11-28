package fr.juery;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.ElementKind;
import javax.lang.model.element.ExecutableElement;
import javax.lang.model.element.VariableElement;

import com.sun.source.doctree.DocCommentTree;
import com.sun.source.util.DocTrees;

import jdk.javadoc.doclet.Doclet;
import jdk.javadoc.doclet.DocletEnvironment;
import jdk.javadoc.doclet.Reporter;

/**
 * A minimal doclet that just prints out the names of the
 * selected elements.
 */
public class MarkletPlus implements Doclet {

    /**
     * Méthode d'initialisation de la Doclet.
     */
    @Override
    public void init(Locale locale, Reporter reporter) {
        System.out.println( ">>> Doclet is initialized" );
    }

    /**
     * Renvoie le nom de la Doclet (ici, le nom de la classe).
     */
    @Override
    public String getName() {
        return getClass().getSimpleName();
    }

    @Override
    public Set<? extends Option> getSupportedOptions() {
        System.out.println( ">>> In getSupportedOptions" );
        return Collections.emptySet();
    }

    @Override
    public SourceVersion getSupportedSourceVersion() {
        System.out.println( ">>> In getSupportedSourceVersion" );
        return SourceVersion.latest();
    }


    /**
     * Le point d'entrée de notre doclet de test.
     *
     * @param environment Représente l'environnement de la Doclet.
     */
    @Override
    public boolean run(DocletEnvironment environment) {
        System.out.println( ">>> In getSupportedSourceVersion" );

        // Un arbre de noeuds de commentaires Javadoc
        DocTrees trees = environment.getDocTrees();

        // On parcourt l'arbre syntaxique du code analysé.
        for ( Element element : environment.getSpecifiedElements() ) {

            // On affiche le nom de la classe et sa documentation.
            DocCommentTree tree = trees.getDocCommentTree( element );
            System.out.printf( "Type %s : %s\n",
                    element.getSimpleName(),
                    tree != null ? tree.toString() : "" );

            // On parcourt tous les membres du type courant et
            // on affiche un éventuel commentaire Javadoc.
            List<Element> constructors = element.getEnclosedElements().stream().filter( e -> e.getKind() == ElementKind.CONSTRUCTOR).collect(Collectors.toList());
            for( Element member : constructors ) {
            //for( Element member : element.getEnclosedElements() ) {
                DocCommentTree memberTree = trees.getDocCommentTree( member );
                System.out.printf( "\t%s - %s - %s\n",
                        member.toString(),
                        member.getKind().toString(),
                        memberTree != null ? memberTree.toString() : "" );

                // Si le membre est une méthode ou un constructeur, on liste les paramètres
                if ( Arrays.asList( ElementKind.METHOD,
                        ElementKind.CONSTRUCTOR ).contains( member.getKind() ) ) {
                    ExecutableElement methodElement = (ExecutableElement) member;
                    List<? extends VariableElement> parameters = methodElement.getParameters();
                    for (VariableElement parameter : parameters) {
                        System.out.printf( "\t\t%s - %s\n",
                                parameter.getSimpleName(),
                                parameter.asType().toString() );
                    }
                }
            }
        }

        return true; // Le traitement se termine correctement.
    }

    /**
     * Le constructeur de notre Doclet.
     */
    public MarkletPlus() {
        super();
    }
}