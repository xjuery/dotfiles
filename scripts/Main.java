package fr.juery;

import javax.tools.DocumentationTool;

public class Main {
    public static void main(String[] args) {
        DocumentationTool tool = javax.tools.ToolProvider.getSystemDocumentationTool();
        tool.run(System.in, System.out, System.err, new String[] {
            "-docletpath",
            "/media/Data/Projets/MarkletPlus/src/main/java/fr/juery",
            "-doclet",
            "fr.juery.MarkletPlus",
            "/media/Data/Projets/MarkletPlus/src/main/java/fr/juery/MarkletPlus.java"
        });
    }
}