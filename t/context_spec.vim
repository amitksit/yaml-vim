scriptencoding utf-8

describe 'Context'
  before
    let b:subject = yaml#Context({'indent_width': 2})
  end
  
  describe '#GetNextIndent(line, indent)'
    context 'when the `line` was structures'
      it 'should do not indent'
        Expect copy(b:subject).GetNextIndent('---', 0) == 0
        Expect copy(b:subject).GetNextIndent('--- ', 0) == 0
      end
      
      context 'with tags'
        it 'should do not indent'
          Expect copy(b:subject).GetNextIndent('--- !!tag', 0) == 0
          Expect copy(b:subject).GetNextIndent('--- !!tag ', 0) == 0
        end
      end
      
      context 'with scalar start symbols(">" and "|")'
        it 'should do indent'
          Expect copy(b:subject).GetNextIndent("--- \>", 0) == 2
          Expect copy(b:subject).GetNextIndent("--- \> ", 0) == 2
          
          Expect copy(b:subject).GetNextIndent('--- |', 0) == 2
          Expect copy(b:subject).GetNextIndent('--- | ', 0) == 2
        end
        
        context 'when tags existed before it'
          it 'should do indent'
            Expect copy(b:subject).GetNextIndent("--- !!tag \>", 0) == 2
            Expect copy(b:subject).GetNextIndent("--- !!tag \> ", 0) == 2
            
            Expect copy(b:subject).GetNextIndent('--- !!tag |', 0) == 2
            Expect copy(b:subject).GetNextIndent('--- !!tag | ', 0) == 2
          end
        end
        
        context 'when not existed spaces before the scalar start symbols'
          it 'should do not indent'
            Expect copy(b:subject).GetNextIndent("---\>", 0) == 0
            Expect copy(b:subject).GetNextIndent("---\> ", 0) == 0
            
            Expect copy(b:subject).GetNextIndent('---|', 0) == 0
            Expect copy(b:subject).GetNextIndent('---| ', 0) == 0
          end
        end
      end
    end
    
    context 'when the `line` was scalar start symbols(">" and "|")'
      it 'should do indent'
        Expect copy(b:subject).GetNextIndent("\>", 0) == 2
        Expect copy(b:subject).GetNextIndent("\> ", 0) == 2
        
        Expect copy(b:subject).GetNextIndent('|', 0) == 2
        Expect copy(b:subject).GetNextIndent('| ', 0) == 2
      end
      
      context 'when tags existed before it'
        it 'should do indent'
          Expect copy(b:subject).GetNextIndent("!!tag \>", 0) == 2
          Expect copy(b:subject).GetNextIndent("!!tag \> ", 0) == 2
          
          Expect copy(b:subject).GetNextIndent('!!tag |', 0) == 2
          Expect copy(b:subject).GetNextIndent('!!tag | ', 0) == 2
        end
      end
      
      context 'when existed spaces before the scalar start symbols'
        it 'should do not indent'
          Expect copy(b:subject).GetNextIndent(" \>", 0) == 0
          Expect copy(b:subject).GetNextIndent(" \> ", 0) == 0
          
          Expect copy(b:subject).GetNextIndent(' |', 0) == 0
          Expect copy(b:subject).GetNextIndent(' | ', 0) == 0
        end
      end
    end
    
    context 'when the `line` was mappings collection'
      it 'should do indent'
        Expect copy(b:subject).GetNextIndent('hoge:', 0) == 2
        Expect copy(b:subject).GetNextIndent('hoge: ', 0) == 2
      end
      
      context 'with tags'
        it 'should do indent'
          Expect copy(b:subject).GetNextIndent('hoge: !!tag', 0) == 2
          Expect copy(b:subject).GetNextIndent('hoge: !!tag ', 0) == 2
        end
      end
      
      context 'with scalar start symbols(">" and "|")'
        it 'should do indent'
          Expect copy(b:subject).GetNextIndent("hoge: \>", 0) == 2
          Expect copy(b:subject).GetNextIndent("hoge: \> ", 0) == 2
          
          Expect copy(b:subject).GetNextIndent('hoge: |', 0) == 2
          Expect copy(b:subject).GetNextIndent('hoge: | ', 0) == 2
        end
        
        context 'when tags existed before it'
          it 'should do indent'
            Expect copy(b:subject).GetNextIndent("hoge: !!tag \>", 0) == 2
            Expect copy(b:subject).GetNextIndent("hoge: !!tag \> ", 0) == 2
            
            Expect copy(b:subject).GetNextIndent('hoge: !!tag |', 0) == 2
            Expect copy(b:subject).GetNextIndent('hoge: !!tag | ', 0) == 2
          end
        end
        
        context 'when not existed spaces between ":" and the scalar start symbols'
          it 'should do not indent'
            Expect copy(b:subject).GetNextIndent("hoge:\>", 0) == 0
            Expect copy(b:subject).GetNextIndent("hoge:\> ", 0) == 0
            
            Expect copy(b:subject).GetNextIndent('hoge:|', 0) == 0
            Expect copy(b:subject).GetNextIndent('hoge:| ', 0) == 0
          end
        end
      end
    end
    
    context 'when the `line` was sequence collection'
      it 'should do indent'
        Expect copy(b:subject).GetNextIndent('-', 0) == 2
        Expect copy(b:subject).GetNextIndent('- ', 0) == 2
      end
      
      context 'with tags'
        it 'should do indent'
          Expect copy(b:subject).GetNextIndent('- !!tag', 0) == 2
          Expect copy(b:subject).GetNextIndent('- !!tag ', 0) == 2
        end
      end
      
      context 'with mappings collection'
        it 'should do double indent'
          Expect copy(b:subject).GetNextIndent('- hoge:', 0) == 4
          Expect copy(b:subject).GetNextIndent('- hoge: ', 0) == 4
        end
        
        context 'with tags'
          it 'should do double indent'
            Expect copy(b:subject).GetNextIndent('- hoge: !!tag', 0) == 4
            Expect copy(b:subject).GetNextIndent('- hoge: !!tag ', 0) == 4
          end
        end
        
        context 'with a value part'
          it 'should do indent'
            Expect copy(b:subject).GetNextIndent('- hoge: 1', 0) == 2
            Expect copy(b:subject).GetNextIndent('- hoge: 1 ', 0) == 2
          end
          
          context 'with tags'
            it 'should do indent'
              Expect copy(b:subject).GetNextIndent('- hoge: !!tag 1', 0) == 2
              Expect copy(b:subject).GetNextIndent('- hoge: !!tag 1 ', 0) == 2
            end
          end
        end
        
        context 'with scalar start symbols'
          it 'should do double indent'
            Expect copy(b:subject).GetNextIndent("- hoge: \>", 0) == 4
            Expect copy(b:subject).GetNextIndent("- hoge: \> ", 0) == 4
          end
          
          context 'when tags existed before it'
            it 'should do indent'
              Expect copy(b:subject).GetNextIndent("- hoge: !!tag \>", 0) == 4
              Expect copy(b:subject).GetNextIndent("- hoge: !!tag \> ", 0) == 4
            end
          end
        end
      end
      
      context 'with scalar start symbols(">" and "|")'
        it 'should do indent'
          Expect copy(b:subject).GetNextIndent("- \>", 0) == 2
          Expect copy(b:subject).GetNextIndent("- \> ", 0) == 2
          
          Expect copy(b:subject).GetNextIndent('- |', 0) == 2
          Expect copy(b:subject).GetNextIndent('- | ', 0) == 2
        end
        
        context 'when tags existed before it'
          it 'should do indent'
            Expect copy(b:subject).GetNextIndent("- !!tag \>", 0) == 2
            Expect copy(b:subject).GetNextIndent("- !!tag \> ", 0) == 2
            
            Expect copy(b:subject).GetNextIndent('- !!tag |', 0) == 2
            Expect copy(b:subject).GetNextIndent('- !!tag | ', 0) == 2
          end
        end
        
        context 'when not existed spaces between "-" and the scalar start symbols'
          it 'should do not indent'
            Expect copy(b:subject).GetNextIndent("-\>", 0) == 0
            Expect copy(b:subject).GetNextIndent("-\> ", 0) == 0
            
            Expect copy(b:subject).GetNextIndent('-|', 0) == 0
            Expect copy(b:subject).GetNextIndent('-| ', 0) == 0
          end
        end
      end
    end
  end
end
