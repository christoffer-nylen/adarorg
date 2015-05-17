----------------------------------------------------------------------
--  AdaRORG_Constants - Package specification                       --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

package Adarorg_Constants is

   STACK_SIZE : constant Positive := 100;

   --Maximum number of clauses per predicate
   PREDICATE_SIZE : constant Positive := 11;

   NO_ID : constant Integer := 0;

   ------------------------------------------------------------
   -- INSTRUMENTATION                                        --
   ------------------------------------------------------------
   ADA_BODY_FILE_EXTENSION : constant String := ".adb";
   RORG_INSTRUMENTED_FILE_EXTENSION : constant String := ".ror";

   subtype String_Type is Wide_String;
   WITH_TOK : constant String_Type := "with";
   RORG_PACKAGE : constant String_Type := "Rorg";
   ADA_BODY_FILE_EXTENSION_TOK : constant String_Type := ".adb";
   CONCATENATE_TOK : constant String_Type := "&";
   FUNCTION_TOK : constant String_Type := "function";
   FUNCTION_NAME_TOK : constant String_Type := "RORG_Mark_";
   LOOP_VARIABLE_TYPE_TOK : constant String_Type := "Integer";
   PARAMETER_DELIMITER_TOK : constant String_Type := "; ";
   ARGUMENT_DELIMITER_TOK : constant String_Type := ", ";
   IS_TOK : constant String_Type := "is";
   BEGIN_TOK : constant String_Type := "begin";
   BOOLEAN_TOK : constant String_Type := "Boolean";
   RETURN_TOK : constant String_Type := "return";
   AND_TOK : constant String_Type := "and";
   OR_TOK : constant String_Type := "or";
   XOR_TOK : constant String_Type := "xor";
   NOT_TOK : constant String_Type := "not";
   TRUE_TOK : constant String_Type := "True";
   FALSE_TOK : constant String_Type := "False";
   END_TOK : constant String_Type := "end";
   EQUALS_TOK : constant String_Type := "=";
   ASSIGN_TOK : constant String_Type := ":=";
   IMPLIES_TOK : constant String_Type := "=>";
   SINGLE_QUOTE_TOK : constant String_Type := "'";
   COLON_TOK : constant String_Type := ":";
   SEMI_COLON_TOK : constant String_Type := ";";
   COMMA_TOK : constant String_Type := ",";
   DOT_TOK : constant String_Type := ".";
   EXCLAMATION_MARK_TOK : constant String_Type := "!";
   LEFT_PAREN_TOK : constant String_Type := "(";
   RIGHT_PAREN_TOK : constant String_Type := ")";
   LEFT_BR_TOK : constant String_Type := "[";
   RIGHT_BR_TOK : constant String_Type := "]";
   PLUS_ONE_TOK : constant String_Type := "+1";
   RORG_COVERAGE_ARRAY_TOK : constant String_Type := "Is_Covered";
   SPACE_TOK : constant String_Type := " ";
   IF_NOT_TOK : constant String_Type := "if not";
   IF_TOK : constant String_Type := "if";
   THEN_TOK : constant String_Type := "then";
   ELSE_TOK : constant String_Type := "else";
   END_IF_TOK : constant String_Type := "end if";
   INDENT_SPACE_TOK : constant String_Type := "   ";
   INDENT_SIZE : constant Positive := 3;

   -- Temporary variable
   CLAUSE_ARG : constant String_Type := "Clause_";
   CLAUSE_ARG_LEFT : constant String_Type := "Left_Arg_Temp";
   CLAUSE_ARG_RIGHT : constant String_Type := "Right_Arg_Temp";
   UNDERSCORE_TOK : constant String_Type := "_";
   NONE_RELATIONAL_CLAUSE : constant String_Type := "Temp";

   -- COMMENTS
   ADDITIONAL_INFO_COMMENT : constant String_Type := "Exceptions        :";
   IS_FIRST_COMMENT : constant String_Type := "is lower bound";
   IS_LAST_COMMENT : constant String_Type := "is higher bound";
   IS_REGULAR_CLAUSE_COMMENT : constant String_Type := "is a non-relational clause";
   NOT_TESTED_COMMENT : constant String_Type := "(will not be RORG tested)";
   COMMENT_TOK : constant String_Type := "--";
   LOCATION_COMMENT : constant String_Type := "Location          :";
   ABSTRACT_EXPRESSION_COMMENT : constant String_Type := "Predicate         :";
   RORG_MARK_COMMENT : constant String_Type := "Source Expression :";
   TEST_CASE_COMMENT : constant String_Type := "Test Case      :";
   DETERMINING_CLAUSES_COMMENT : constant String_Type := "Active Clauses :";
   CLAUSE_COMMENT : constant String_Type := "Clause";
   COVERED_FOR : constant String_Type := "is covered";
   SPACE21_TOK : constant String_Type := "                     ";

   ------------------------------------------------------------
   -- MESSAGES                                               --
   ------------------------------------------------------------
   CONTEXT_UNIT_NOT_FOUND_MESSAGE : constant String_Type := "Context does not contain the requested unit: ";
   CONTEXT_UNITS_AVAILABLE_MESSAGE : constant String_Type := "Compilation units in context:";
   CONTEXT_UNIT_FOUND_MESSAGE : constant String_Type := "Context contains the requested unit: ";
   STATUS_VALUE_MESSAGE : constant String_Type := "Status Value is ";

   ------------------------------------------------------------
   -- EXCEPTIONS                                             --
   ------------------------------------------------------------
   CONTEXT_UNIT_NOT_FOUND : exception;

   ------------------------------------------------------------
   -- Regular Expressions                                    --
   ------------------------------------------------------------
   PATH_PATTERN : constant String := "([a-zA-Z_/]+/)";
   UNIT_PATTERN : constant String := "([^.]+)";

   ------------------------------------------------------------
   -- REPORT & FILELIST                                      --
   ------------------------------------------------------------
   HEADER_LINE_BOLD : constant String_Type :=
     "================================================================================";
   HEADER_LINE_2 : constant String_Type :=
     "        ";
   ADARORG :         constant String_Type := "AdaRORG 2015";
   ADARORG_VERSION : constant String_Type := "Version 0.1r1";
   HEADER_LINE_THIN : constant String_Type :=
     "--------------------------------------------------------------------------------";
   HEADER_LINE_3_STATIC  : constant String_Type := "        Static Analysis for ";
   HEADER_LINE_4_STATIC  : constant String_Type := "        Analysis run on ";
   HEADER_LINE_3_DYNAMIC : constant String_Type := "        Test Results for ";
   HEADER_LINE_4_DYNAMIC : constant String_Type := "        Test run on ";

   PATH_NAME :                    constant String_Type := "Path: ";
   INDENT_ONE :                   constant String_Type := " ";
   NUMBER_OF_PREDICATES :         constant String_Type := " Predicates";
   NUMBER_OF_PREDICATES_LINE :    constant String_Type := " ----------";
   NUMBER_OF_RELOPS :             constant String_Type := " Relational operators";
   NUMBER_OF_RELOPS_LINE  :       constant String_Type := " --------------------";
   TOTAL_ONE :                    constant String_Type := "  Total        : ";
   INSTRUMENTED_ONE :             constant String_Type := "  Instrumented : ";
   INSTRUMENTATION_DETAILS :      constant String_Type := " Instrumentation details";
   INSTRUMENTATION_DETAILS_LINE : constant String_Type := " -----------------------";
   INDENT_TWO :                   constant String_Type := "   ";
   ENUMERATION_TYPE :             constant String_Type := "   Enumeration type";
   ENUMERATION_TYPE_LINE :        constant String_Type := "   ----------------";
   INTEGER_TYPE :                 constant String_Type := "   Integer type";
   INTEGER_TYPE_LINE :            constant String_Type := "   ------------";
   REAL_TYPE :                    constant String_Type := "   Real type";
   REAL_TYPE_LINE :               constant String_Type := "   ---------";
   TOTAL_TWO :                    constant String_Type := "    Total      : ";
end Adarorg_Constants;
