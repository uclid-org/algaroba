// Generated from /home/hung/Dropbox/work/svn/svn_trusted_verification_rada/rada/src/rada/RadaGrammar.g4 by ANTLR 4.1

package rada;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link RadaGrammarParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface RadaGrammarVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandPush}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandPush(@NotNull RadaGrammarParser.CommandPushContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#idSymbol}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdSymbol(@NotNull RadaGrammarParser.IdSymbolContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandGetAssign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandGetAssign(@NotNull RadaGrammarParser.CommandGetAssignContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#mainProgram}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMainProgram(@NotNull RadaGrammarParser.MainProgramContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandSetOption}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandSetOption(@NotNull RadaGrammarParser.CommandSetOptionContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#termExistsTerm}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermExistsTerm(@NotNull RadaGrammarParser.TermExistsTermContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandAssert}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandAssert(@NotNull RadaGrammarParser.CommandAssertContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandGetProof}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandGetProof(@NotNull RadaGrammarParser.CommandGetProofContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#specConstString}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecConstString(@NotNull RadaGrammarParser.SpecConstStringContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandGetOption}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandGetOption(@NotNull RadaGrammarParser.CommandGetOptionContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#infoFlagKeyword}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInfoFlagKeyword(@NotNull RadaGrammarParser.InfoFlagKeywordContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandCheckSat}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandCheckSat(@NotNull RadaGrammarParser.CommandCheckSatContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#termExclimationPt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermExclimationPt(@NotNull RadaGrammarParser.TermExclimationPtContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#specConstsHex}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecConstsHex(@NotNull RadaGrammarParser.SpecConstsHexContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#normalSymbol}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNormalSymbol(@NotNull RadaGrammarParser.NormalSymbolContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandGetUnsatCore}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandGetUnsatCore(@NotNull RadaGrammarParser.CommandGetUnsatCoreContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandSetLogic}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandSetLogic(@NotNull RadaGrammarParser.CommandSetLogicContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#termForAllTerm}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermForAllTerm(@NotNull RadaGrammarParser.TermForAllTermContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#termQualIdentifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermQualIdentifier(@NotNull RadaGrammarParser.TermQualIdentifierContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#attributeValSymbol}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttributeValSymbol(@NotNull RadaGrammarParser.AttributeValSymbolContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandDefineFun}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandDefineFun(@NotNull RadaGrammarParser.CommandDefineFunContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandSetInfo}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandSetInfo(@NotNull RadaGrammarParser.CommandSetInfoContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#sexprInParen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSexprInParen(@NotNull RadaGrammarParser.SexprInParenContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandGetAssert}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandGetAssert(@NotNull RadaGrammarParser.CommandGetAssertContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#symbolWithOr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSymbolWithOr(@NotNull RadaGrammarParser.SymbolWithOrContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#varBindingSymTerm}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVarBindingSymTerm(@NotNull RadaGrammarParser.VarBindingSymTermContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#attributeKeyword}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttributeKeyword(@NotNull RadaGrammarParser.AttributeKeywordContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#declareDatatypes}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclareDatatypes(@NotNull RadaGrammarParser.DeclareDatatypesContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#qualIdentifierAs}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitQualIdentifierAs(@NotNull RadaGrammarParser.QualIdentifierAsContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#attributeValSpecConst}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttributeValSpecConst(@NotNull RadaGrammarParser.AttributeValSpecConstContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandGetValue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandGetValue(@NotNull RadaGrammarParser.CommandGetValueContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#sortedVarSymSort}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSortedVarSymSort(@NotNull RadaGrammarParser.SortedVarSymSortContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#termSpecConst}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermSpecConst(@NotNull RadaGrammarParser.TermSpecConstContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#termQualIdTerm}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermQualIdTerm(@NotNull RadaGrammarParser.TermQualIdTermContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandDeclareSort}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandDeclareSort(@NotNull RadaGrammarParser.CommandDeclareSortContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#termLetTerm}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermLetTerm(@NotNull RadaGrammarParser.TermLetTermContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#sexprSymbol}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSexprSymbol(@NotNull RadaGrammarParser.SexprSymbolContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#defineCatamorphism}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDefineCatamorphism(@NotNull RadaGrammarParser.DefineCatamorphismContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#catamorphism}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCatamorphism(@NotNull RadaGrammarParser.CatamorphismContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#qualIdentifierId}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitQualIdentifierId(@NotNull RadaGrammarParser.QualIdentifierIdContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#specConstNum}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecConstNum(@NotNull RadaGrammarParser.SpecConstNumContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#anOptionAttribute}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAnOptionAttribute(@NotNull RadaGrammarParser.AnOptionAttributeContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#dtypebranch}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDtypebranch(@NotNull RadaGrammarParser.DtypebranchContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#parameter}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter(@NotNull RadaGrammarParser.ParameterContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#specConstsBinary}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecConstsBinary(@NotNull RadaGrammarParser.SpecConstsBinaryContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#catbody}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCatbody(@NotNull RadaGrammarParser.CatbodyContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#sortIdentifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSortIdentifier(@NotNull RadaGrammarParser.SortIdentifierContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#attributeValSexpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttributeValSexpr(@NotNull RadaGrammarParser.AttributeValSexprContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#sortIdSortMulti}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSortIdSortMulti(@NotNull RadaGrammarParser.SortIdSortMultiContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#idUnderscoreSymNum}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdUnderscoreSymNum(@NotNull RadaGrammarParser.IdUnderscoreSymNumContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandPop}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandPop(@NotNull RadaGrammarParser.CommandPopContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandDefineSort}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandDefineSort(@NotNull RadaGrammarParser.CommandDefineSortContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandExit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandExit(@NotNull RadaGrammarParser.CommandExitContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#specConstsDec}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSpecConstsDec(@NotNull RadaGrammarParser.SpecConstsDecContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandGetInfo}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandGetInfo(@NotNull RadaGrammarParser.CommandGetInfoContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#attributeKeywordValue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAttributeKeywordValue(@NotNull RadaGrammarParser.AttributeKeywordValueContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#postcond}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPostcond(@NotNull RadaGrammarParser.PostcondContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#commandDeclareFun}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommandDeclareFun(@NotNull RadaGrammarParser.CommandDeclareFunContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#sexprSpecConst}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSexprSpecConst(@NotNull RadaGrammarParser.SexprSpecConstContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#datatype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDatatype(@NotNull RadaGrammarParser.DatatypeContext ctx);

	/**
	 * Visit a parse tree produced by {@link RadaGrammarParser#sexprKeyword}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSexprKeyword(@NotNull RadaGrammarParser.SexprKeywordContext ctx);
}