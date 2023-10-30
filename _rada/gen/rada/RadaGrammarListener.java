// Generated from /home/hung/Dropbox/work/svn/svn_trusted_verification_rada/rada/src/rada/RadaGrammar.g4 by ANTLR 4.1

package rada;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link RadaGrammarParser}.
 */
public interface RadaGrammarListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandPush}.
	 * @param ctx the parse tree
	 */
	void enterCommandPush(@NotNull RadaGrammarParser.CommandPushContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandPush}.
	 * @param ctx the parse tree
	 */
	void exitCommandPush(@NotNull RadaGrammarParser.CommandPushContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#idSymbol}.
	 * @param ctx the parse tree
	 */
	void enterIdSymbol(@NotNull RadaGrammarParser.IdSymbolContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#idSymbol}.
	 * @param ctx the parse tree
	 */
	void exitIdSymbol(@NotNull RadaGrammarParser.IdSymbolContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandGetAssign}.
	 * @param ctx the parse tree
	 */
	void enterCommandGetAssign(@NotNull RadaGrammarParser.CommandGetAssignContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandGetAssign}.
	 * @param ctx the parse tree
	 */
	void exitCommandGetAssign(@NotNull RadaGrammarParser.CommandGetAssignContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#mainProgram}.
	 * @param ctx the parse tree
	 */
	void enterMainProgram(@NotNull RadaGrammarParser.MainProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#mainProgram}.
	 * @param ctx the parse tree
	 */
	void exitMainProgram(@NotNull RadaGrammarParser.MainProgramContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandSetOption}.
	 * @param ctx the parse tree
	 */
	void enterCommandSetOption(@NotNull RadaGrammarParser.CommandSetOptionContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandSetOption}.
	 * @param ctx the parse tree
	 */
	void exitCommandSetOption(@NotNull RadaGrammarParser.CommandSetOptionContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#termExistsTerm}.
	 * @param ctx the parse tree
	 */
	void enterTermExistsTerm(@NotNull RadaGrammarParser.TermExistsTermContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#termExistsTerm}.
	 * @param ctx the parse tree
	 */
	void exitTermExistsTerm(@NotNull RadaGrammarParser.TermExistsTermContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandAssert}.
	 * @param ctx the parse tree
	 */
	void enterCommandAssert(@NotNull RadaGrammarParser.CommandAssertContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandAssert}.
	 * @param ctx the parse tree
	 */
	void exitCommandAssert(@NotNull RadaGrammarParser.CommandAssertContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandGetProof}.
	 * @param ctx the parse tree
	 */
	void enterCommandGetProof(@NotNull RadaGrammarParser.CommandGetProofContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandGetProof}.
	 * @param ctx the parse tree
	 */
	void exitCommandGetProof(@NotNull RadaGrammarParser.CommandGetProofContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#specConstString}.
	 * @param ctx the parse tree
	 */
	void enterSpecConstString(@NotNull RadaGrammarParser.SpecConstStringContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#specConstString}.
	 * @param ctx the parse tree
	 */
	void exitSpecConstString(@NotNull RadaGrammarParser.SpecConstStringContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandGetOption}.
	 * @param ctx the parse tree
	 */
	void enterCommandGetOption(@NotNull RadaGrammarParser.CommandGetOptionContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandGetOption}.
	 * @param ctx the parse tree
	 */
	void exitCommandGetOption(@NotNull RadaGrammarParser.CommandGetOptionContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#infoFlagKeyword}.
	 * @param ctx the parse tree
	 */
	void enterInfoFlagKeyword(@NotNull RadaGrammarParser.InfoFlagKeywordContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#infoFlagKeyword}.
	 * @param ctx the parse tree
	 */
	void exitInfoFlagKeyword(@NotNull RadaGrammarParser.InfoFlagKeywordContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandCheckSat}.
	 * @param ctx the parse tree
	 */
	void enterCommandCheckSat(@NotNull RadaGrammarParser.CommandCheckSatContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandCheckSat}.
	 * @param ctx the parse tree
	 */
	void exitCommandCheckSat(@NotNull RadaGrammarParser.CommandCheckSatContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#termExclimationPt}.
	 * @param ctx the parse tree
	 */
	void enterTermExclimationPt(@NotNull RadaGrammarParser.TermExclimationPtContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#termExclimationPt}.
	 * @param ctx the parse tree
	 */
	void exitTermExclimationPt(@NotNull RadaGrammarParser.TermExclimationPtContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#specConstsHex}.
	 * @param ctx the parse tree
	 */
	void enterSpecConstsHex(@NotNull RadaGrammarParser.SpecConstsHexContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#specConstsHex}.
	 * @param ctx the parse tree
	 */
	void exitSpecConstsHex(@NotNull RadaGrammarParser.SpecConstsHexContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#normalSymbol}.
	 * @param ctx the parse tree
	 */
	void enterNormalSymbol(@NotNull RadaGrammarParser.NormalSymbolContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#normalSymbol}.
	 * @param ctx the parse tree
	 */
	void exitNormalSymbol(@NotNull RadaGrammarParser.NormalSymbolContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandGetUnsatCore}.
	 * @param ctx the parse tree
	 */
	void enterCommandGetUnsatCore(@NotNull RadaGrammarParser.CommandGetUnsatCoreContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandGetUnsatCore}.
	 * @param ctx the parse tree
	 */
	void exitCommandGetUnsatCore(@NotNull RadaGrammarParser.CommandGetUnsatCoreContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandSetLogic}.
	 * @param ctx the parse tree
	 */
	void enterCommandSetLogic(@NotNull RadaGrammarParser.CommandSetLogicContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandSetLogic}.
	 * @param ctx the parse tree
	 */
	void exitCommandSetLogic(@NotNull RadaGrammarParser.CommandSetLogicContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#termForAllTerm}.
	 * @param ctx the parse tree
	 */
	void enterTermForAllTerm(@NotNull RadaGrammarParser.TermForAllTermContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#termForAllTerm}.
	 * @param ctx the parse tree
	 */
	void exitTermForAllTerm(@NotNull RadaGrammarParser.TermForAllTermContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#termQualIdentifier}.
	 * @param ctx the parse tree
	 */
	void enterTermQualIdentifier(@NotNull RadaGrammarParser.TermQualIdentifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#termQualIdentifier}.
	 * @param ctx the parse tree
	 */
	void exitTermQualIdentifier(@NotNull RadaGrammarParser.TermQualIdentifierContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#attributeValSymbol}.
	 * @param ctx the parse tree
	 */
	void enterAttributeValSymbol(@NotNull RadaGrammarParser.AttributeValSymbolContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#attributeValSymbol}.
	 * @param ctx the parse tree
	 */
	void exitAttributeValSymbol(@NotNull RadaGrammarParser.AttributeValSymbolContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandDefineFun}.
	 * @param ctx the parse tree
	 */
	void enterCommandDefineFun(@NotNull RadaGrammarParser.CommandDefineFunContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandDefineFun}.
	 * @param ctx the parse tree
	 */
	void exitCommandDefineFun(@NotNull RadaGrammarParser.CommandDefineFunContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandSetInfo}.
	 * @param ctx the parse tree
	 */
	void enterCommandSetInfo(@NotNull RadaGrammarParser.CommandSetInfoContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandSetInfo}.
	 * @param ctx the parse tree
	 */
	void exitCommandSetInfo(@NotNull RadaGrammarParser.CommandSetInfoContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#sexprInParen}.
	 * @param ctx the parse tree
	 */
	void enterSexprInParen(@NotNull RadaGrammarParser.SexprInParenContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#sexprInParen}.
	 * @param ctx the parse tree
	 */
	void exitSexprInParen(@NotNull RadaGrammarParser.SexprInParenContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandGetAssert}.
	 * @param ctx the parse tree
	 */
	void enterCommandGetAssert(@NotNull RadaGrammarParser.CommandGetAssertContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandGetAssert}.
	 * @param ctx the parse tree
	 */
	void exitCommandGetAssert(@NotNull RadaGrammarParser.CommandGetAssertContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#symbolWithOr}.
	 * @param ctx the parse tree
	 */
	void enterSymbolWithOr(@NotNull RadaGrammarParser.SymbolWithOrContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#symbolWithOr}.
	 * @param ctx the parse tree
	 */
	void exitSymbolWithOr(@NotNull RadaGrammarParser.SymbolWithOrContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#varBindingSymTerm}.
	 * @param ctx the parse tree
	 */
	void enterVarBindingSymTerm(@NotNull RadaGrammarParser.VarBindingSymTermContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#varBindingSymTerm}.
	 * @param ctx the parse tree
	 */
	void exitVarBindingSymTerm(@NotNull RadaGrammarParser.VarBindingSymTermContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#attributeKeyword}.
	 * @param ctx the parse tree
	 */
	void enterAttributeKeyword(@NotNull RadaGrammarParser.AttributeKeywordContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#attributeKeyword}.
	 * @param ctx the parse tree
	 */
	void exitAttributeKeyword(@NotNull RadaGrammarParser.AttributeKeywordContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#declareDatatypes}.
	 * @param ctx the parse tree
	 */
	void enterDeclareDatatypes(@NotNull RadaGrammarParser.DeclareDatatypesContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#declareDatatypes}.
	 * @param ctx the parse tree
	 */
	void exitDeclareDatatypes(@NotNull RadaGrammarParser.DeclareDatatypesContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#qualIdentifierAs}.
	 * @param ctx the parse tree
	 */
	void enterQualIdentifierAs(@NotNull RadaGrammarParser.QualIdentifierAsContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#qualIdentifierAs}.
	 * @param ctx the parse tree
	 */
	void exitQualIdentifierAs(@NotNull RadaGrammarParser.QualIdentifierAsContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#attributeValSpecConst}.
	 * @param ctx the parse tree
	 */
	void enterAttributeValSpecConst(@NotNull RadaGrammarParser.AttributeValSpecConstContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#attributeValSpecConst}.
	 * @param ctx the parse tree
	 */
	void exitAttributeValSpecConst(@NotNull RadaGrammarParser.AttributeValSpecConstContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandGetValue}.
	 * @param ctx the parse tree
	 */
	void enterCommandGetValue(@NotNull RadaGrammarParser.CommandGetValueContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandGetValue}.
	 * @param ctx the parse tree
	 */
	void exitCommandGetValue(@NotNull RadaGrammarParser.CommandGetValueContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#sortedVarSymSort}.
	 * @param ctx the parse tree
	 */
	void enterSortedVarSymSort(@NotNull RadaGrammarParser.SortedVarSymSortContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#sortedVarSymSort}.
	 * @param ctx the parse tree
	 */
	void exitSortedVarSymSort(@NotNull RadaGrammarParser.SortedVarSymSortContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#termSpecConst}.
	 * @param ctx the parse tree
	 */
	void enterTermSpecConst(@NotNull RadaGrammarParser.TermSpecConstContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#termSpecConst}.
	 * @param ctx the parse tree
	 */
	void exitTermSpecConst(@NotNull RadaGrammarParser.TermSpecConstContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#termQualIdTerm}.
	 * @param ctx the parse tree
	 */
	void enterTermQualIdTerm(@NotNull RadaGrammarParser.TermQualIdTermContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#termQualIdTerm}.
	 * @param ctx the parse tree
	 */
	void exitTermQualIdTerm(@NotNull RadaGrammarParser.TermQualIdTermContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandDeclareSort}.
	 * @param ctx the parse tree
	 */
	void enterCommandDeclareSort(@NotNull RadaGrammarParser.CommandDeclareSortContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandDeclareSort}.
	 * @param ctx the parse tree
	 */
	void exitCommandDeclareSort(@NotNull RadaGrammarParser.CommandDeclareSortContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#termLetTerm}.
	 * @param ctx the parse tree
	 */
	void enterTermLetTerm(@NotNull RadaGrammarParser.TermLetTermContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#termLetTerm}.
	 * @param ctx the parse tree
	 */
	void exitTermLetTerm(@NotNull RadaGrammarParser.TermLetTermContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#sexprSymbol}.
	 * @param ctx the parse tree
	 */
	void enterSexprSymbol(@NotNull RadaGrammarParser.SexprSymbolContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#sexprSymbol}.
	 * @param ctx the parse tree
	 */
	void exitSexprSymbol(@NotNull RadaGrammarParser.SexprSymbolContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#defineCatamorphism}.
	 * @param ctx the parse tree
	 */
	void enterDefineCatamorphism(@NotNull RadaGrammarParser.DefineCatamorphismContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#defineCatamorphism}.
	 * @param ctx the parse tree
	 */
	void exitDefineCatamorphism(@NotNull RadaGrammarParser.DefineCatamorphismContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#catamorphism}.
	 * @param ctx the parse tree
	 */
	void enterCatamorphism(@NotNull RadaGrammarParser.CatamorphismContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#catamorphism}.
	 * @param ctx the parse tree
	 */
	void exitCatamorphism(@NotNull RadaGrammarParser.CatamorphismContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#qualIdentifierId}.
	 * @param ctx the parse tree
	 */
	void enterQualIdentifierId(@NotNull RadaGrammarParser.QualIdentifierIdContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#qualIdentifierId}.
	 * @param ctx the parse tree
	 */
	void exitQualIdentifierId(@NotNull RadaGrammarParser.QualIdentifierIdContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#specConstNum}.
	 * @param ctx the parse tree
	 */
	void enterSpecConstNum(@NotNull RadaGrammarParser.SpecConstNumContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#specConstNum}.
	 * @param ctx the parse tree
	 */
	void exitSpecConstNum(@NotNull RadaGrammarParser.SpecConstNumContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#anOptionAttribute}.
	 * @param ctx the parse tree
	 */
	void enterAnOptionAttribute(@NotNull RadaGrammarParser.AnOptionAttributeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#anOptionAttribute}.
	 * @param ctx the parse tree
	 */
	void exitAnOptionAttribute(@NotNull RadaGrammarParser.AnOptionAttributeContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#dtypebranch}.
	 * @param ctx the parse tree
	 */
	void enterDtypebranch(@NotNull RadaGrammarParser.DtypebranchContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#dtypebranch}.
	 * @param ctx the parse tree
	 */
	void exitDtypebranch(@NotNull RadaGrammarParser.DtypebranchContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#parameter}.
	 * @param ctx the parse tree
	 */
	void enterParameter(@NotNull RadaGrammarParser.ParameterContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#parameter}.
	 * @param ctx the parse tree
	 */
	void exitParameter(@NotNull RadaGrammarParser.ParameterContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#specConstsBinary}.
	 * @param ctx the parse tree
	 */
	void enterSpecConstsBinary(@NotNull RadaGrammarParser.SpecConstsBinaryContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#specConstsBinary}.
	 * @param ctx the parse tree
	 */
	void exitSpecConstsBinary(@NotNull RadaGrammarParser.SpecConstsBinaryContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#catbody}.
	 * @param ctx the parse tree
	 */
	void enterCatbody(@NotNull RadaGrammarParser.CatbodyContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#catbody}.
	 * @param ctx the parse tree
	 */
	void exitCatbody(@NotNull RadaGrammarParser.CatbodyContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#sortIdentifier}.
	 * @param ctx the parse tree
	 */
	void enterSortIdentifier(@NotNull RadaGrammarParser.SortIdentifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#sortIdentifier}.
	 * @param ctx the parse tree
	 */
	void exitSortIdentifier(@NotNull RadaGrammarParser.SortIdentifierContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#attributeValSexpr}.
	 * @param ctx the parse tree
	 */
	void enterAttributeValSexpr(@NotNull RadaGrammarParser.AttributeValSexprContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#attributeValSexpr}.
	 * @param ctx the parse tree
	 */
	void exitAttributeValSexpr(@NotNull RadaGrammarParser.AttributeValSexprContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#sortIdSortMulti}.
	 * @param ctx the parse tree
	 */
	void enterSortIdSortMulti(@NotNull RadaGrammarParser.SortIdSortMultiContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#sortIdSortMulti}.
	 * @param ctx the parse tree
	 */
	void exitSortIdSortMulti(@NotNull RadaGrammarParser.SortIdSortMultiContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#idUnderscoreSymNum}.
	 * @param ctx the parse tree
	 */
	void enterIdUnderscoreSymNum(@NotNull RadaGrammarParser.IdUnderscoreSymNumContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#idUnderscoreSymNum}.
	 * @param ctx the parse tree
	 */
	void exitIdUnderscoreSymNum(@NotNull RadaGrammarParser.IdUnderscoreSymNumContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandPop}.
	 * @param ctx the parse tree
	 */
	void enterCommandPop(@NotNull RadaGrammarParser.CommandPopContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandPop}.
	 * @param ctx the parse tree
	 */
	void exitCommandPop(@NotNull RadaGrammarParser.CommandPopContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandDefineSort}.
	 * @param ctx the parse tree
	 */
	void enterCommandDefineSort(@NotNull RadaGrammarParser.CommandDefineSortContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandDefineSort}.
	 * @param ctx the parse tree
	 */
	void exitCommandDefineSort(@NotNull RadaGrammarParser.CommandDefineSortContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandExit}.
	 * @param ctx the parse tree
	 */
	void enterCommandExit(@NotNull RadaGrammarParser.CommandExitContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandExit}.
	 * @param ctx the parse tree
	 */
	void exitCommandExit(@NotNull RadaGrammarParser.CommandExitContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#specConstsDec}.
	 * @param ctx the parse tree
	 */
	void enterSpecConstsDec(@NotNull RadaGrammarParser.SpecConstsDecContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#specConstsDec}.
	 * @param ctx the parse tree
	 */
	void exitSpecConstsDec(@NotNull RadaGrammarParser.SpecConstsDecContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandGetInfo}.
	 * @param ctx the parse tree
	 */
	void enterCommandGetInfo(@NotNull RadaGrammarParser.CommandGetInfoContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandGetInfo}.
	 * @param ctx the parse tree
	 */
	void exitCommandGetInfo(@NotNull RadaGrammarParser.CommandGetInfoContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#attributeKeywordValue}.
	 * @param ctx the parse tree
	 */
	void enterAttributeKeywordValue(@NotNull RadaGrammarParser.AttributeKeywordValueContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#attributeKeywordValue}.
	 * @param ctx the parse tree
	 */
	void exitAttributeKeywordValue(@NotNull RadaGrammarParser.AttributeKeywordValueContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#postcond}.
	 * @param ctx the parse tree
	 */
	void enterPostcond(@NotNull RadaGrammarParser.PostcondContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#postcond}.
	 * @param ctx the parse tree
	 */
	void exitPostcond(@NotNull RadaGrammarParser.PostcondContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#commandDeclareFun}.
	 * @param ctx the parse tree
	 */
	void enterCommandDeclareFun(@NotNull RadaGrammarParser.CommandDeclareFunContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#commandDeclareFun}.
	 * @param ctx the parse tree
	 */
	void exitCommandDeclareFun(@NotNull RadaGrammarParser.CommandDeclareFunContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#sexprSpecConst}.
	 * @param ctx the parse tree
	 */
	void enterSexprSpecConst(@NotNull RadaGrammarParser.SexprSpecConstContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#sexprSpecConst}.
	 * @param ctx the parse tree
	 */
	void exitSexprSpecConst(@NotNull RadaGrammarParser.SexprSpecConstContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#datatype}.
	 * @param ctx the parse tree
	 */
	void enterDatatype(@NotNull RadaGrammarParser.DatatypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#datatype}.
	 * @param ctx the parse tree
	 */
	void exitDatatype(@NotNull RadaGrammarParser.DatatypeContext ctx);

	/**
	 * Enter a parse tree produced by {@link RadaGrammarParser#sexprKeyword}.
	 * @param ctx the parse tree
	 */
	void enterSexprKeyword(@NotNull RadaGrammarParser.SexprKeywordContext ctx);
	/**
	 * Exit a parse tree produced by {@link RadaGrammarParser#sexprKeyword}.
	 * @param ctx the parse tree
	 */
	void exitSexprKeyword(@NotNull RadaGrammarParser.SexprKeywordContext ctx);
}