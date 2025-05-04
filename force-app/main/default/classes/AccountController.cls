public class AccountController {
    // Classe interna não estática
	public static String name = 'Victorino GOmes';
	public Integer age = 9;
    public static void hellox(integer x){
        System.debug('HHH '+ x +' name'+ name+' Age: ');
        //tryIn(7);
    }
    public void tryIn(integer x){
        AccountController.name='Josué';
        System.debug('HHH '+x+' age: '+age);
        
        AccountController.hellox(9);
    }
    public class MyClassOne {
        public void sayHello() {
            System.debug('Hello from MyClassOne');
        }
    }
}